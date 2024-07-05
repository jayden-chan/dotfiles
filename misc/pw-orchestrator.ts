#!/usr/bin/env -S bun run

// @ts-ignore
const HOME = process.env["HOME"] ?? "/home/jayden";
// @ts-ignore
const TV_MODE = process.env["TV_MODE"] ?? "false";

const SYSTEM_EQ = "System Equalizer";
const DX5_DEV = "DX5 Pro";
const S_4i4_DEV = "Scarlett 4i4 USB Pro";
const SPC_TRV_DEV = "Moondrop Space Travel";
const BATHYS_DEV = "Focal Bathys";
const HDMI_DEV = "HDMI Output";

const UNLINK = "pipewire::unlink";
const LINK = "pipewire::link";

type SinkMode = "Pro" | "Basic";
type InOut = "In" | "Out";
type LR = "L" | "R";

const Pro: SinkMode = "Pro";
const Basic: SinkMode = "Basic";
const In: InOut = "In";
const Out: InOut = "Out";
const L: LR = "L";
const R: LR = "R";

const pbc = (o: InOut) => (o === In ? "playback" : "capture");
const pbm = (o: InOut) => (o === In ? "playback" : "monitor");
const inc = (o: InOut) => (o === In ? "input" : "capture");
const full = (o: InOut) => (o === In ? "Input" : "Output");
const sinkTemplate =
  (node: string, nodeGen: (o: InOut) => string, sinkMode: SinkMode) =>
  (o: InOut, p: LR) => ({
    node,
    port: `${nodeGen(o)}_${
      sinkMode === "Basic" ? `F${p}` : `AUX${p === "L" ? "0" : "1"}`
    }`,
  });

const DX5 = sinkTemplate(DX5_DEV, pbc, Pro);
const AOUT = sinkTemplate("Audio Output", pbm, Basic);
const ASINK = sinkTemplate("Audio Device", pbm, Basic);
const M_SINK = sinkTemplate("Mic Sink", pbm, Basic);
const SPC_TRV = sinkTemplate(SPC_TRV_DEV, pbc, Basic);
const BATHYS = sinkTemplate(BATHYS_DEV, pbc, Basic);
const MIC = sinkTemplate("Microphone", inc, Basic);
const HDMI = sinkTemplate(HDMI_DEV, pbm, Pro);
const SCARLETT_METER = (p: LR) => ({ node: "Scarlett Meter", port: `In${p}` });

const EQ = (o: InOut, p: LR) => ({
  node: SYSTEM_EQ,
  port: `${o.toLowerCase()}_${p.toLowerCase()}`,
});

const MIC_TOGGLE = (p: LR) => ({
  node: "Mic Toggle",
  port: `Audio Output ${p === L ? 1 : 2}`,
});

const MIXER = (o: InOut, p: LR, num: number) => ({
  node: "Mixer",
  port: `Audio ${full(o)} ${p === L ? num * 2 - 1 : num * 2}`,
});

const S_4i4 = (o: InOut, p: number) => ({
  node: S_4i4_DEV,
  port: `${pbc(o)}_AUX${p}`,
});

const DIAL_MANAGER = (dial: number, button: string, rangeEnd: number) => {
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
              { type: "range", dial: dialStr, range: [0, rangeEnd] },
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
              { type: UNLINK, src: MIXER(Out, L, dial), dest: M_SINK(In, L) },
              { type: UNLINK, src: MIXER(Out, R, dial), dest: M_SINK(In, R) },
              { type: LINK, src: MIXER(Out, L, dial), dest: ASINK(In, L) },
              { type: LINK, src: MIXER(Out, R, dial), dest: ASINK(In, R) },
            ],
            [
              { type: UNLINK, src: MIXER(Out, L, dial), dest: ASINK(In, L) },
              { type: UNLINK, src: MIXER(Out, R, dial), dest: ASINK(In, R) },
              { type: LINK, src: MIXER(Out, L, dial), dest: M_SINK(In, L) },
              { type: LINK, src: MIXER(Out, R, dial), dest: M_SINK(In, R) },
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
  cancelable: boolean
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
          command: `mpv --no-config --volume=${volume.toFixed(
            0
          )} --no-terminal --audio-device=pulse/mic-sink ${path}`,
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
    defaultLEDStateAlways: "AMBER",
    onLongPress: { actions: eqPresetActions("sink-Flat", button) },
    onPress: { actions: eqPresetActions(name, button) },
  };
};

const EQ_PRESET_BINDS = {
  "Button 1": "sink-Companion_2",
  "Button 2": "sink-Focal_Clear",
  "Button 3": "sink-Focal_Bathys",
  "Button 4": "sink-Truthear_Hexa",
  "Button 5": "sink-Moondrop_Space_Travel",
};
const ALL_EQ_BUTTONS = Object.keys(EQ_PRESET_BINDS);

const SFX_BINDS: Record<string, [string, number, boolean]> = {
  "Button 33": ["~/Documents/SFX/knock.mp3", 100, false],
  "Button 34": ["~/Documents/SFX/discord.wav", 80, false],
  "Button 35": ["~/Documents/SFX/Badum_tss.mp3", 70, false],
  "Button 36": ["~/Documents/SFX/rev_it_up.mp3", 70, true],
  "Button 25": ["~/Documents/SFX/Gentlemen.mp3", 100, true],
  "Button 26": ["~/Documents/SFX/ritz.mp3", 70, true],
  "Button 27": ["~/Documents/SFX/chips.mp3", 60, true],
  "Button 28": ["~/Documents/SFX/Allahu_Akbar.mp3", 55, true],
  "Button 17": ["~/Documents/SFX/csgo_ready.opus", 100, true],
  "Button 18": ["~/Documents/SFX/NFL_fuzz2.ogg", 70, true],
  "Button 19": ["~/Documents/SFX/NFL_clean.ogg", 95, true],
  "Button 20": ["~/Documents/SFX/metal_pipe.ogg", 80, true],
  "Button 9": ["~/Documents/SFX/star_wars.ogg", 80, true],
  "Button 10": [
    "~/Documents/SFX/minecraft-alpha-damage-sound-effect.mp3",
    100,
    false,
  ],
  "Button 11": ["~/Documents/SFX/yippee.ogg", 80, true],
};

const DIAL_MANAGER_BINDS: Record<string, [number, number]> = {
  "Button 37": [1, 0.5],
  "Button 38": [2, 0.5],
  "Button 39": [3, 0.5],
  "Button 40": [4, 0.5],
  "Button 29": [5, 0.5],
  "Button 30": [6, 0.5],
  "Button 31": [7, 0.5],
  "Button 32": [8, 0.35],
};

const config = {
  device: "APC Key 25 MIDI",
  stateFile: `${HOME}/.local/state/pw-orchestrator.json`,
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
  lv2Path: `/usr/lib/lv2:${HOME}/.config/dotfiles/afx/lv2`,
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
      { node: "TrackmaniaUplay", mixerChannel: "round_robin" },
      { node: "re:csgo_linux64.*", mixerChannel: 6 },
      { node: "re:.*cs2.*", mixerChannel: 6 },
      { node: "re:.*SDL Application.*", mixerChannel: 6 },
      { node: "WEBRTC VoiceEngine", mixerChannel: 7 },
      {
        node: SPC_TRV_DEV,
        onDisconnect: [
          { type: LINK, src: EQ(Out, L), dest: DX5(In, L) },
          { type: LINK, src: EQ(Out, R), dest: DX5(In, R) },
        ],
        onConnect: [
          ...eqPresetActions(
            "sink-Moondrop_Space_Travel",
            Object.entries(EQ_PRESET_BINDS).find(
              (e) => e[1] === "sink-Moondrop_Space_Travel"
            )![0]
          ),
          { type: UNLINK, src: EQ(Out, L), dest: DX5(In, L) },
          { type: UNLINK, src: EQ(Out, R), dest: DX5(In, R) },
          { type: LINK, src: EQ(Out, L), dest: SPC_TRV(In, L) },
          { type: LINK, src: EQ(Out, R), dest: SPC_TRV(In, R) },
        ],
      },
      {
        node: `re:^${BATHYS_DEV}(-\\d+)?$`,
        onDisconnect: [
          { type: LINK, src: EQ(Out, L), dest: DX5(In, L) },
          { type: LINK, src: EQ(Out, R), dest: DX5(In, R) },
        ],
        onConnect: [
          ...eqPresetActions(
            "sink-Focal_Bathys",
            Object.entries(EQ_PRESET_BINDS).find(
              (e) => e[1] === "sink-Focal_Bathys"
            )![0]
          ),
          { type: UNLINK, src: EQ(Out, L), dest: DX5(In, L) },
          { type: UNLINK, src: EQ(Out, R), dest: DX5(In, R) },
          { type: LINK, src: EQ(Out, L), dest: BATHYS(In, L) },
          { type: LINK, src: EQ(Out, R), dest: BATHYS(In, R) },
        ],
      },
      {
        node: SYSTEM_EQ,
        onConnect: [
          { type: LINK, src: ASINK(Out, L), dest: EQ(In, L) },
          { type: LINK, src: ASINK(Out, R), dest: EQ(In, R) },
          { type: LINK, src: EQ(Out, L), dest: DX5(In, L) },
          { type: LINK, src: EQ(Out, R), dest: DX5(In, R) },
          { type: LINK, src: EQ(Out, L), dest: SPC_TRV(In, L) },
          { type: LINK, src: EQ(Out, R), dest: SPC_TRV(In, R) },
          { type: LINK, src: EQ(Out, L), dest: BATHYS(In, L) },
          { type: LINK, src: EQ(Out, R), dest: BATHYS(In, R) },
          { type: LINK, src: M_SINK(Out, L), dest: EQ(In, L) },
          { type: LINK, src: M_SINK(Out, R), dest: EQ(In, R) },
        ],
      },
      {
        node: DX5_DEV,
        onConnect: [
          { type: LINK, src: EQ(Out, L), dest: DX5(In, L) },
          { type: LINK, src: EQ(Out, R), dest: DX5(In, R) },
        ],
      },
      {
        node: S_4i4_DEV,
        onConnect: [
          { type: LINK, src: S_4i4(Out, 0), dest: SCARLETT_METER(L) },
        ],
      },
      ...(TV_MODE === "true"
        ? [
            {
              node: HDMI_DEV,
              onConnect: [
                { type: LINK, src: EQ(Out, L), dest: HDMI(In, L) },
                { type: LINK, src: EQ(Out, R), dest: HDMI(In, R) },
              ],
            },
          ]
        : []),
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
    Rec: {
      type: "button",
      onPress: {
        actions: [
          {
            type: "command",
            command:
              `killall -SIGUSR1 gpu-screen-recorder ` +
              `&& notify-send "gpu-screen-recorder" "Clip saved" ` +
              `|| notify-send -u critical "gpu-screen-recorder" "ERROR!!! ERROR!! Clip failed to save"`,
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
    "Clip Stop": {
      type: "button",
      defaultLEDState: "OFF",
      onPress: {
        actions: [
          {
            type: "command",
            command: "~/.config/dotfiles/scripts/rofi.sh --liquidctl",
          },
        ],
      },
    },
    Solo: {
      type: "button",
      defaultLEDState: "OFF",
      onPress: {
        actions: [
          { type: LINK, src: EQ(Out, L), dest: BATHYS(In, L) },
          { type: LINK, src: EQ(Out, R), dest: BATHYS(In, R) },
        ],
      },
    },
    "Rec Arm": {
      type: "button",
      defaultLEDState: "ON",
      onPress: {
        actions: [
          {
            type: "cycle",
            actions: [
              [
                { type: "led::set", button: "Rec Arm", color: "ON" },
                { type: LINK, src: S_4i4(Out, 2), dest: MIXER(In, L, 4) },
                { type: LINK, src: S_4i4(Out, 3), dest: MIXER(In, R, 4) },
                { type: LINK, src: MIC_TOGGLE(L), dest: S_4i4(In, 0) },
                { type: LINK, src: MIC_TOGGLE(R), dest: S_4i4(In, 0) },
              ],
              [
                { type: "led::set", button: "Rec Arm", color: "OFF" },
                { type: UNLINK, src: S_4i4(Out, 2), dest: MIXER(In, L, 4) },
                { type: UNLINK, src: S_4i4(Out, 3), dest: MIXER(In, R, 4) },
                { type: UNLINK, src: MIC_TOGGLE(L), dest: S_4i4(In, 0) },
                { type: UNLINK, src: MIC_TOGGLE(R), dest: S_4i4(In, 0) },
              ],
            ],
          },
        ],
      },
    },
    Mute: {
      type: "button",
      defaultLEDState: "ON",
      onPress: {
        actions: [
          {
            type: "cycle",
            actions: [
              [
                { type: "led::set", button: "Mute", color: "OFF" },
                {
                  type: "midi",
                  events: [
                    {
                      type: "CONTROL_CHANGE",
                      channel: 4,
                      controller: 12,
                      value: 0,
                    },
                  ],
                },
              ],
              [
                { type: "led::set", button: "Mute", color: "ON" },
                {
                  type: "midi",
                  events: [
                    {
                      type: "CONTROL_CHANGE",
                      channel: 4,
                      controller: 12,
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
    Select: {
      type: "button",
      defaultLEDState: "ON",
      onPress: {
        actions: [
          {
            type: "cycle",
            actions: [
              [
                { type: "led::set", button: "Select", color: "OFF" },
                {
                  type: "midi",
                  events: [
                    {
                      type: "CONTROL_CHANGE",
                      channel: 4,
                      controller: 13,
                      value: 0,
                    },
                  ],
                },
              ],
              [
                { type: "led::set", button: "Select", color: "ON" },
                {
                  type: "midi",
                  events: [
                    {
                      type: "CONTROL_CHANGE",
                      channel: 4,
                      controller: 13,
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
    "Button 23": {
      type: "button",
      defaultLEDState: "RED",
      onPress: {
        actions: [
          {
            type: "cycle",
            actions: [
              [
                { type: "led::set", button: "Button 23", color: "RED" },
                {
                  type: "command",
                  command: "ha input_boolean living_room_lights_toggle off",
                },
              ],
              [
                { type: "led::set", button: "Button 23", color: "GREEN" },
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
    "Button 24": {
      type: "button",
      defaultLEDState: "RED",
      onPress: {
        actions: [
          {
            type: "cycle",
            actions: [
              [
                { type: "led::set", button: "Button 24", color: "RED" },
                {
                  type: "command",
                  command: "ha input_boolean led_strip_toggle off",
                },
              ],
              [
                { type: "led::set", button: "Button 24", color: "GREEN" },
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
    "Button 14": {
      type: "button",
      defaultLEDStateAlways: "AMBER",
      onPress: {
        actions: [
          {
            type: "command",
            command: "openrgb --mode static --color D0D7FE",
          },
          { type: "led::set", button: "Button 14", color: "GREEN" },
        ],
      },
      onLongPress: {
        actions: [
          {
            type: "command",
            command: "openrgb --mode static --color 000000",
          },
          { type: "led::set", button: "Button 14", color: "RED" },
        ],
      },
    },
    "Button 15": {
      type: "button",
      defaultLEDStateAlways: "GREEN",
      onPress: {
        actions: [
          {
            type: "command",
            command: `picom --config ~/.config/dotfiles/misc/picom.conf`,
          },
          { type: "led::set", button: "Button 15", color: "GREEN" },
        ],
      },
      onLongPress: {
        actions: [
          {
            type: "command",
            command: "killall picom",
            onFinish: [
              { type: "led::set", button: "Button 15", color: "AMBER" },
              {
                type: "command",
                command:
                  "pgrep -x gpu-screen-reco > /dev/null || notify-send -u critical 'WARNING' 'gpu-screen-recorder is not running'",
              },
            ],
          },
        ],
      },
    },
    "Button 16": {
      type: "button",
      defaultLEDState: "AMBER",
      onPress: {
        actions: [
          {
            type: "command",
            command:
              "ha set_led_strip on $(convert /usr/share/backgrounds/wall +dither -colors 1 -unique-colors txt: | rg '(#[0-9A-F]{6})' --only-matching --replace='$1')",
          },
        ],
      },
    },
    "Button 22": {
      type: "button",
      defaultLEDState: "AMBER",
      onPress: {
        actions: [
          {
            type: "command",
            command:
              "~/.config/dotfiles/misc/pw-orchestrator.ts > /tmp/pw-orchestrator-config.json",
            cancelable: false,
            onFinish: [
              { type: "config::reload" },
              {
                type: "command",
                command: `notify-send "PipeWire Orchestrator" "Reloading config"`,
              },
            ],
          },
        ],
      },
    },
    "Stop All Clips": {
      type: "button",
      onPress: {
        actions: [
          {
            type: "cancel",
            alt: {
              type: "command",
              command: `notify-send "PipeWire Orchestrator" "No pending action to cancel"`,
            },
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
                value: 64,
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
                value: 47,
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
                { type: UNLINK, src: MIC(Out, L), dest: AOUT(In, L) },
                { type: UNLINK, src: MIC(Out, R), dest: AOUT(In, R) },
                { type: LINK, src: M_SINK(Out, L), dest: EQ(In, L) },
                { type: LINK, src: M_SINK(Out, R), dest: EQ(In, R) },
              ],
              [
                { type: "led::set", button: "Send", color: "ON" },
                { type: LINK, src: MIC(Out, L), dest: AOUT(In, L) },
                { type: LINK, src: MIC(Out, R), dest: AOUT(In, R) },
                { type: UNLINK, src: M_SINK(Out, L), dest: EQ(In, L) },
                { type: UNLINK, src: M_SINK(Out, R), dest: EQ(In, R) },
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

Object.entries(SFX_BINDS).forEach(([button, sfxBind]) => {
  config.bindings[button] = SFX(button, ...sfxBind);
});

Object.entries(DIAL_MANAGER_BINDS).forEach(([button, [dial, rangeEnd]]) => {
  config.bindings[button] = DIAL_MANAGER(dial, button, rangeEnd);
});

console.log(JSON.stringify(config));
