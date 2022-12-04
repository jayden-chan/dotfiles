#!/usr/bin/env -S deno run --allow-env --no-lock

const SYSTEM_EQ = "System Equalizer";
const DX5_OUT = "Topping DX5 Output";
const QC35_OUT = "Bose QuietComfort 35";
const UNLINK = "pipewire::unlink";
const LINK = "pipewire::link";

const SYSTEM_EQ_IN_L = { node: SYSTEM_EQ, port: "in_l" };
const SYSTEM_EQ_IN_R = { node: SYSTEM_EQ, port: "in_r" };
const SYSTEM_EQ_OUT_L = { node: SYSTEM_EQ, port: "out_l" };
const SYSTEM_EQ_OUT_R = { node: SYSTEM_EQ, port: "out_r" };

const DX5_L = { node: DX5_OUT, port: "playback_FL" };
const DX5_R = { node: DX5_OUT, port: "playback_FR" };

const SCARLETT_GUITAR = { node: "Scarlett Meter", port: "OutR" };

const AOUT_OUT_L = { node: "Audio Output", port: "monitor_FL" };
const AOUT_OUT_R = { node: "Audio Output", port: "monitor_FR" };
const AOUT_IN_L = { node: "Audio Output", port: "playback_FL" };
const AOUT_IN_R = { node: "Audio Output", port: "playback_FR" };

const METAL_AMP = { node: "Metal Amp", port: "Audio Input 1" };
const METAL_AMP_L = { node: "Metal Amp", port: "Audio Output 1" };
const METAL_AMP_R = { node: "Metal Amp", port: "Audio Output 2" };
const CLEAN_AMP = { node: "Clean Amp", port: "Audio Input 1" };
const CLEAN_AMP_L = { node: "Clean Amp", port: "Audio Output 1" };
const CLEAN_AMP_R = { node: "Clean Amp", port: "Audio Output 2" };
const QC35_L = { node: QC35_OUT, port: "playback_FL" };
const QC35_R = { node: QC35_OUT, port: "playback_FR" };

const home = Deno.env.get("HOME") ?? "/home/jayden";

const MIXER_R = (num: number) => ({
  node: "Mixer",
  port: `Audio Input ${num * 2}`,
});
const MIXER_L = (num: number) => ({
  node: "Mixer",
  port: `Audio Input ${num * 2 - 1}`,
});

const DIAL_MANAGER = (dial: number, button: string, rangeEnd?: number) => {
  const dialStr = `Dial ${dial}`;
  return {
    type: "button",
    defaultLEDState: "GREEN",
    // mixer selection mode
    onShiftLongPress: {
      actions: [
        {
          type: "mixer::select",
          onFinish: [{ type: "led::restore", button }],
          channel: dial,
        },
        { type: "led::save", button },
        { type: "led::set", button, color: "AMBER_FLASHING" },
      ],
    },
    // range toggle
    onShiftPress: {
      actions: [
        {
          type: "cycle",
          actions: [
            [
              { type: "led::set", button, color: "GREEN" },
              { type: "range", dial: dialStr, range: [0, 1] },
            ],
            [
              { type: "led::set", button, color: "AMBER" },
              { type: "range", dial: dialStr, range: [0, rangeEnd ?? 0.5] },
            ],
          ],
        },
      ],
    },
    // send to microphone
    onLongPress: {
      actions: [
        {
          type: "cycle",
          actions: [
            [
              {
                type: UNLINK,
                src: { node: "Mixer", port: `Audio Output ${dial * 2 - 1}` },
                dest: { node: "Mic Sink", port: "playback_FL" },
              },
              {
                type: UNLINK,
                src: { node: "Mixer", port: `Audio Output ${dial * 2}` },
                dest: { node: "Mic Sink", port: "playback_FR" },
              },
              {
                type: LINK,
                src: { node: "Mixer", port: `Audio Output ${dial * 2 - 1}` },
                dest: AOUT_IN_L,
              },
              {
                type: LINK,
                src: { node: "Mixer", port: `Audio Output ${dial * 2}` },
                dest: AOUT_IN_R,
              },
            ],
            [
              {
                type: UNLINK,
                src: { node: "Mixer", port: `Audio Output ${dial * 2 - 1}` },
                dest: AOUT_IN_L,
              },
              {
                type: UNLINK,
                src: { node: "Mixer", port: `Audio Output ${dial * 2}` },
                dest: AOUT_IN_R,
              },
              {
                type: LINK,
                src: { node: "Mixer", port: `Audio Output ${dial * 2 - 1}` },
                dest: { node: "Mic Sink", port: "playback_FL" },
              },
              {
                type: LINK,
                src: { node: "Mixer", port: `Audio Output ${dial * 2}` },
                dest: { node: "Mic Sink", port: "playback_FR" },
              },
            ],
          ],
        },
      ],
    },
    // toggle mute
    onPress: {
      actions: [
        {
          type: "cycle",
          actions: [
            [
              { type: "led::set", button, color: "GREEN" },
              { type: "mute", mute: false, dial: `Dial ${dial}` },
            ],
            [
              { type: "led::set", button, color: "RED" },
              { type: "mute", mute: true, dial: `Dial ${dial}` },
            ],
          ],
        },
      ],
    },
  };
};

const PASSTHROUGH = (outController: number, mapFunction?: string) => {
  return {
    type: "passthrough",
    mapFunction: mapFunction ?? "TAPER",
    outChannel: 4,
    outController,
  };
};

const SFX = (
  button: string,
  path: string,
  volume: number,
  cancelable?: boolean
) => {
  return {
    type: "button",
    defaultLEDState: "GREEN",
    onPress: {
      actions: [
        {
          type: "command",
          cancelable: cancelable !== undefined ? cancelable : false,
          onFinish: [{ type: "led::set", button, color: "GREEN" }],
          command: `mpv --no-config --volume=${
            volume ?? 100
          } --no-terminal --audio-device=pulse/mic-sink ${path}`,
        },
        { type: "led::set", button, color: "AMBER" },
      ],
    },
  };
};

const eqPresetActions = (name: string, button: string) => {
  const isFlat = name === "sink-Flat";
  const cleanName = isFlat
    ? "Disabled"
    : `Preset ${name.replace("sink-", "").replace(/_/g, " ")} loaded`;

  const ledCommands = ALL_EQ_BUTTONS.map((b) => {
    if (isFlat || b !== button) {
      return {
        type: "led::set",
        button: b,
        color: "AMBER",
      };
    } else {
      return {
        type: "led::set",
        button: b,
        color: "GREEN",
      };
    }
  });

  return [
    {
      type: "lv2::load_preset",
      pluginName: "System Equalizer",
      preset: `https://lv2.jayden.codes/presets/${name}`,
    },
    ...ledCommands,
    {
      type: "command",
      command: `notify-send "PipeWire Orchestrator" "EQ ${cleanName}"`,
    },
  ];
};

const EQ_PRESET = (name: string, button: string) => {
  return {
    type: "button",
    defaultLEDState: "AMBER",
    onLongPress: {
      actions: eqPresetActions("sink-Flat", button),
    },
    onPress: {
      actions: eqPresetActions(name, button),
    },
  };
};

const EQ_PRESET_BINDS = {
  "Button 1": "sink-HE400i",
  "Button 2": "sink-QC35",
  "Button 3": "sink-QC35_Wireless",
  "Button 4": "sink-Companion_2",
  "Button 5": "sink-HD_560S",
  "Button 6": "sink-Focal_Clear",
};
const ALL_EQ_BUTTONS = Object.keys(EQ_PRESET_BINDS);

const config = {
  device: "APC Key 25 MIDI",
  inputMidi: "virt:2",
  outputMidi: "virt:1",
  connections: [
    ["APC Key 25", "Virtual Raw MIDI 0-2"],
    ["APC Key 25", "Virtual Raw MIDI 1-2"],
    ["APC Key 25", "Virtual Raw MIDI 2-2"],
    ["APC Key 25", "Virtual Raw MIDI 3-2"],
    ["APC Key 25", "Virtual Raw MIDI 4-2"],
    ["APC Key 25", "Virtual Raw MIDI 5-2"],

    ["Virtual Raw MIDI 0-1", "APC Key 25"],
    ["Virtual Raw MIDI 1-1", "APC Key 25"],
    ["Virtual Raw MIDI 2-1", "APC Key 25"],
    ["Virtual Raw MIDI 3-1", "APC Key 25"],
    ["Virtual Raw MIDI 4-1", "APC Key 25"],
    ["Virtual Raw MIDI 5-1", "APC Key 25"],
  ],
  lv2Path: `/usr/lib/lv2:${home}/.config/dotfiles/afx/lv2`,
  pipewire: {
    plugins: [
      {
        uri: "http://lsp-plug.in/plugins/lv2/para_equalizer_x16_stereo",
        name: "System Equalizer",
        host: "jalv",
      },
    ],
    rules: [
      { node: "re:.*bf4\\.exe.*", mixerChannel: "round_robin" },
      { node: "re:.*Battlefield 4.*", mixerChannel: "round_robin" },
      { node: "re:.*Overwatch\\.exe.*", mixerChannel: "round_robin" },
      { node: "Chromium", mixerChannel: "round_robin" },
      { node: "re:(F|f)irefox.*", mixerChannel: 5 },
      { node: "re:csgo_linux64*", mixerChannel: 6 },
      { node: "WEBRTC VoiceEngine", mixerChannel: 7 },
      { node: "spotify", mixerChannel: 8 },
      {
        node: QC35_OUT,
        onDisconnect: [
          ...eqPresetActions(
            "sink-QC35",
            Object.entries(EQ_PRESET_BINDS).find(
              (e) => e[1] === "sink-QC35"
            )![0]
          ),
          { type: LINK, src: SYSTEM_EQ_OUT_L, dest: DX5_L },
          { type: LINK, src: SYSTEM_EQ_OUT_R, dest: DX5_R },
        ],
        onConnect: [
          ...eqPresetActions(
            "sink-QC35_Wireless",
            Object.entries(EQ_PRESET_BINDS).find(
              (e) => e[1] === "sink-QC35_Wireless"
            )![0]
          ),
          { type: UNLINK, src: SYSTEM_EQ_OUT_L, dest: DX5_L },
          { type: UNLINK, src: SYSTEM_EQ_OUT_R, dest: DX5_R },
          { type: LINK, src: SYSTEM_EQ_OUT_L, dest: QC35_L },
          { type: LINK, src: SYSTEM_EQ_OUT_R, dest: QC35_R },
        ],
      },
      {
        node: SYSTEM_EQ,
        onConnect: [
          { type: LINK, src: AOUT_OUT_L, dest: SYSTEM_EQ_IN_L },
          { type: LINK, src: AOUT_OUT_R, dest: SYSTEM_EQ_IN_R },
          { type: LINK, src: SYSTEM_EQ_OUT_L, dest: DX5_L },
          { type: LINK, src: SYSTEM_EQ_OUT_R, dest: DX5_R },
          { type: LINK, src: SYSTEM_EQ_OUT_L, dest: QC35_L },
          { type: LINK, src: SYSTEM_EQ_OUT_R, dest: QC35_R },
        ],
      },
      {
        node: DX5_OUT,
        onConnect: [
          { type: LINK, src: SYSTEM_EQ_OUT_L, dest: DX5_L },
          { type: LINK, src: SYSTEM_EQ_OUT_R, dest: DX5_R },
        ],
      },
    ],
  },
  bindings: <Record<string, any>>{
    "Play/Pause": {
      type: "button",
      defaultLEDState: "ON",
      onPress: {
        actions: [
          {
            type: "command",
            command: "~/.config/dotfiles/scripts/xf86.sh media PlayPause",
          },
        ],
      },
    },
    Right: {
      type: "button",
      defaultLEDState: "ON",
      onPress: {
        actions: [
          {
            type: "command",
            command: "~/.config/dotfiles/scripts/xf86.sh media Next",
          },
        ],
      },
    },
    Left: {
      type: "button",
      defaultLEDState: "ON",
      onPress: {
        actions: [
          {
            type: "command",
            command: "~/.config/dotfiles/scripts/xf86.sh media Previous",
          },
        ],
      },
    },
    Up: {
      type: "button",
      defaultLEDState: "ON",
      onPress: { actions: [{ type: "command", command: "xdotool key Up" }] },
    },
    Down: {
      type: "button",
      defaultLEDState: "ON",
      onPress: { actions: [{ type: "command", command: "xdotool key Down" }] },
    },
    Select: {
      type: "button",
      defaultLEDState: "ON",
      onPress: { actions: [{ type: "command", command: "xdotool key Enter" }] },
    },
    "Button 7": {
      type: "button",
      defaultLEDState: "RED",
      onPress: {
        actions: [
          {
            type: "cycle",
            actions: [
              [
                { type: "led::set", button: "Button 7", color: "RED" },
                {
                  type: "command",
                  command: "ha input_boolean living_room_lights_toggle off",
                },
              ],
              [
                { type: "led::set", button: "Button 7", color: "GREEN" },
                {
                  type: "command",
                  command: "ha input_boolean living_room_lights_toggle on",
                },
              ],
            ],
          },
        ],
      },
    },
    "Button 8": {
      type: "button",
      defaultLEDState: "RED",
      onPress: {
        actions: [
          {
            type: "cycle",
            actions: [
              [
                { type: "led::set", button: "Button 8", color: "RED" },
                {
                  type: "command",
                  command: "ha input_boolean led_strip_toggle off",
                },
              ],
              [
                { type: "led::set", button: "Button 8", color: "GREEN" },
                {
                  type: "command",
                  command: "ha input_boolean led_strip_toggle on",
                },
              ],
            ],
          },
        ],
      },
    },
    "Button 9": {
      type: "button",
      defaultLEDState: "GREEN",
      onPress: {
        actions: [
          {
            type: "command",
            command: `picom --config ${home}/.config/dotfiles/misc/picom.conf`,
          },
          {
            type: "command",
            command: "killall -SIGINT gpu-screen-recorder",
            onFinish: [
              {
                type: "command",
                command:
                  "notify-send 'gpu-screen-recorder' 'Recording stopped'",
              },
            ],
          },
          { type: "led::set", button: "Button 9", color: "GREEN" },
          { type: "led::set", button: "Button 10", color: "AMBER" },
        ],
      },
      onLongPress: {
        actions: [
          {
            type: "command",
            command: "killall picom",
            onFinish: [
              { type: "led::set", button: "Button 9", color: "AMBER" },
            ],
          },
          {
            type: "command",
            command: "sleep 1",
            onFinish: [
              {
                type: "command",
                command: `notify-send "gpu-screen-recorder" "GPU screen recorder active"`,
              },
              {
                type: "command",
                command: `gpu-screen-recorder -w DP-2 -c mp4 -f 60 -q very_high -r 150 -a carla-sink.monitor -a carla-source -k h265 -o ${home}/Videos/replays`,
              },
              { type: "led::set", button: "Button 10", color: "RED" },
            ],
          },
        ],
      },
    },
    "Button 10": {
      type: "button",
      defaultLEDState: "AMBER",
      onPress: {
        actions: [
          {
            type: "command",
            command: "killall -SIGUSR1 gpu-screen-recorder",
            onFinish: [
              {
                type: "command",
                command: `notify-send "gpu-screen-recorder" "Clip saved"`,
              },
            ],
          },
          { type: "led::set", button: "Button 10", color: "GREEN_FLASHING" },
          {
            type: "command",
            command: "sleep 3",
            onFinish: [{ type: "led::set", button: "Button 10", color: "RED" }],
          },
        ],
      },
    },
    "Button 11": {
      type: "button",
      defaultLEDState: "AMBER",
      onPress: {
        actions: [
          { type: LINK, src: SCARLETT_GUITAR, dest: CLEAN_AMP },
          { type: LINK, src: CLEAN_AMP_L, dest: MIXER_L(6) },
          { type: LINK, src: CLEAN_AMP_R, dest: MIXER_R(6) },
          { type: UNLINK, src: SCARLETT_GUITAR, dest: METAL_AMP },
        ],
      },
    },
    "Button 12": {
      type: "button",
      defaultLEDState: "AMBER",
      onLongPress: {
        actions: [
          { type: UNLINK, src: SCARLETT_GUITAR, dest: METAL_AMP },
          { type: UNLINK, src: SCARLETT_GUITAR, dest: CLEAN_AMP },
          { type: UNLINK, src: METAL_AMP_L, dest: MIXER_L(6) },
          { type: UNLINK, src: METAL_AMP_R, dest: MIXER_R(6) },
          { type: UNLINK, src: CLEAN_AMP_L, dest: MIXER_L(6) },
          { type: UNLINK, src: CLEAN_AMP_R, dest: MIXER_R(6) },
        ],
      },
      onPress: {
        actions: [
          { type: LINK, src: SCARLETT_GUITAR, dest: METAL_AMP },
          { type: LINK, src: METAL_AMP_L, dest: MIXER_L(6) },
          { type: LINK, src: METAL_AMP_R, dest: MIXER_R(6) },
          { type: UNLINK, src: SCARLETT_GUITAR, dest: CLEAN_AMP },
        ],
      },
    },
    "Stop All Clips": {
      type: "button",
      onPress: {
        actions: [
          {
            type: "cancel",
            alt: { type: "command", command: "notify-send testing bruh" },
          },
        ],
      },
    },
    Volume: {
      type: "button",
      defaultLEDState: "OFF",
      onPress: {
        actions: [
          {
            type: "cycle",
            actions: [
              [
                { type: "led::set", button: "Volume", color: "OFF" },
                {
                  type: "midi",
                  events: [
                    {
                      type: "CONTROL_CHANGE",
                      channel: 4,
                      controller: 7,
                      value: 127,
                    },
                  ],
                },
              ],
              [
                { type: "led::set", button: "Volume", color: "ON" },
                {
                  type: "midi",
                  events: [
                    {
                      type: "CONTROL_CHANGE",
                      channel: 4,
                      controller: 7,
                      value: 0,
                    },
                  ],
                },
              ],
            ],
          },
        ],
      },
    },
    Pan: {
      type: "button",
      defaultLEDState: "OFF",
      onPress: {
        actions: [
          { type: "led::set", button: "Pan", color: "ON" },
          {
            type: "midi",
            events: [
              {
                type: "CONTROL_CHANGE",
                channel: 4,
                controller: 8,
                value: 127,
              },
            ],
          },
        ],
      },
      onRelease: {
        actions: [
          { type: "led::set", button: "Pan", color: "OFF" },
          {
            type: "midi",
            events: [
              {
                type: "CONTROL_CHANGE",
                channel: 4,
                controller: 8,
                value: 0,
              },
            ],
          },
        ],
      },
    },
    Send: {
      type: "button",
      defaultLEDState: "OFF",
      onPress: {
        actions: [
          {
            type: "cycle",
            actions: [
              [
                { type: "led::set", button: "Send", color: "OFF" },
                {
                  type: UNLINK,
                  src: { node: "Microphone", port: "capture_FL" },
                  dest: { node: "Audio Output", port: "playback_FL" },
                },
                {
                  type: UNLINK,
                  src: { node: "Microphone", port: "capture_FR" },
                  dest: { node: "Audio Output", port: "playback_FR" },
                },
                {
                  type: LINK,
                  src: { node: "Mic Sink", port: "monitor_FL" },
                  dest: { node: "Audio Output", port: "playback_FL" },
                },
                {
                  type: LINK,
                  src: { node: "Mic Sink", port: "monitor_FR" },
                  dest: { node: "Audio Output", port: "playback_FR" },
                },
              ],
              [
                { type: "led::set", button: "Send", color: "ON" },
                {
                  type: LINK,
                  src: { node: "Microphone", port: "capture_FL" },
                  dest: { node: "Audio Output", port: "playback_FL" },
                },
                {
                  type: LINK,
                  src: { node: "Microphone", port: "capture_FR" },
                  dest: { node: "Audio Output", port: "playback_FR" },
                },
                {
                  type: UNLINK,
                  src: { node: "Mic Sink", port: "monitor_FL" },
                  dest: { node: "Audio Output", port: "playback_FL" },
                },
                {
                  type: UNLINK,
                  src: { node: "Mic Sink", port: "monitor_FR" },
                  dest: { node: "Audio Output", port: "playback_FR" },
                },
              ],
            ],
          },
        ],
      },
    },
    Device: {
      type: "button",
      defaultLEDState: "OFF",
      onLongPress: {
        actions: [
          {
            type: "midi",
            events: [
              {
                type: "CONTROL_CHANGE",
                channel: 4,
                controller: 10,
                value: 127,
              },
            ],
          },
        ],
      },
      onRelease: {
        actions: [
          {
            type: "midi",
            events: [
              {
                type: "CONTROL_CHANGE",
                channel: 4,
                controller: 10,
                value: 0,
              },
            ],
          },
        ],
      },
      onPress: {
        actions: [
          {
            type: "cycle",
            actions: [
              [
                { type: "led::set", button: "Device", color: "OFF" },
                {
                  type: "midi",
                  events: [
                    {
                      type: "CONTROL_CHANGE",
                      channel: 4,
                      controller: 9,
                      value: 0,
                    },
                  ],
                },
              ],
              [
                { type: "led::set", button: "Device", color: "ON" },
                {
                  type: "midi",
                  events: [
                    {
                      type: "CONTROL_CHANGE",
                      channel: 4,
                      controller: 9,
                      value: 127,
                    },
                  ],
                },
              ],
            ],
          },
        ],
      },
    },
    "Button 33": SFX("Button 33", "~/Documents/SFX/knock.mp3", 100),
    "Button 34": SFX("Button 34", "~/Documents/SFX/discord.wav", 80),
    "Button 35": SFX("Button 35", "~/Documents/SFX/Badum_tss.mp3", 70),
    "Button 36": SFX("Button 36", "~/Documents/SFX/rev_it_up.mp3", 70, true),
    "Button 25": SFX("Button 25", "~/Documents/SFX/Gentlemen.mp3", 90, true),
    "Button 26": SFX("Button 26", "~/Documents/SFX/ritz.mp3", 80, true),
    "Button 27": SFX("Button 27", "~/Documents/SFX/chips.mp3", 55, true),
    "Button 28": SFX("Button 28", "~/Documents/SFX/Allahu_Akbar.mp3", 55, true),
    "Button 17": SFX("Button 17", "~/Documents/SFX/csgo_ready.opus", 100, true),
    "Button 37": DIAL_MANAGER(1, "Button 37"),
    "Button 38": DIAL_MANAGER(2, "Button 38"),
    "Button 39": DIAL_MANAGER(3, "Button 39"),
    "Button 40": DIAL_MANAGER(4, "Button 40"),
    "Button 29": DIAL_MANAGER(5, "Button 29"),
    "Button 30": DIAL_MANAGER(6, "Button 30"),
    "Button 31": DIAL_MANAGER(7, "Button 31"),
    "Button 32": DIAL_MANAGER(8, "Button 32", 0.35),
    "Dial 1": PASSTHROUGH(16),
    "Dial 2": PASSTHROUGH(17),
    "Dial 3": PASSTHROUGH(18),
    "Dial 4": PASSTHROUGH(19),
    "Dial 5": PASSTHROUGH(80),
    "Dial 6": PASSTHROUGH(81),
    "Dial 7": PASSTHROUGH(82),
    "Dial 8": PASSTHROUGH(83, "SQUARED"),
  },
};

Object.entries(EQ_PRESET_BINDS).forEach(([button, eqPreset]) => {
  config.bindings[button] = EQ_PRESET(eqPreset, button);
});

console.log(JSON.stringify(config));
