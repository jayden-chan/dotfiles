{ ... }:

{
  home.file.".config/mpv/scripts/all-audio.lua".text = # lua
    ''
      -- Play all audio tracks in the file simultaneously

      local mp = require("mp")

      mp.add_key_binding("%", function()
          mp.set_property("volume", 100)
          mp.set_property("mute", "no")
      end)

      local function activate_all_audio()
          mp.set_property("mute", "no")
          local current_lavfi = mp.get_property("lavfi-complex")

          local count = 0
          for _, track in pairs(mp.get_property_native("track-list")) do
              if track.type == "audio" then
                  count = count + 1
              end
          end

          -- toggle functionality
          if current_lavfi ~= "" then
              if count ~= 0 then
                  mp.osd_message("Playing audio track 1")
                  mp.set_property("lavfi-complex", "[aid1] amix=inputs=1 [ao]")
                  return
              end
          end

          if count == 4 then
              mp.osd_message("Playing 4 audio tracks")
              mp.set_property("lavfi-complex", "[aid1] [aid2] [aid3] [aid4] amix=inputs=4 [ao]")
          elseif count == 3 then
              mp.osd_message("Playing 3 audio tracks")
              mp.set_property("lavfi-complex", "[aid1] [aid2] [aid3] amix=inputs=3 [ao]")
          elseif count == 2 then
              mp.osd_message("Playing 2 audio tracks")
              mp.set_property("lavfi-complex", "[aid1] [aid2] amix=inputs=2 [ao]")
          elseif count == 1 then
              mp.osd_message("Only 1 audio track")
          elseif count == 0 then
              mp.osd_message("No audio tracks")
          end
      end

      mp.add_key_binding("$", activate_all_audio)
      mp.register_event("end-file", function()
          mp.set_property("lavfi-complex", "")
      end)

      mp.register_event("file-loaded", function()
          local input_path = mp.get_property("stream-path")

          -- automatically un-mute and set volume for clips & replays
          if string.find(input_path, "/Replay_") then
              activate_all_audio()
              if string.find(input_path, "_clip") then
                  mp.set_property("volume", 65)
                  mp.set_property("mute", "no")
              else
                  mp.set_property("volume", 85)
                  mp.set_property("mute", "no")
                  mp.set_property("file-local-options/video-aspect-override", "16:9")
              end
          end

          if string.find(input_path, "vlc%-record") then
              activate_all_audio()
              mp.set_property("volume", 50)
              mp.set_property("mute", "no")
          end

          -- un-mute and disable looping for music files
          if string.match(input_path, "%.flac$") then
              mp.set_property("volume", 100)
              mp.set_property("mute", "no")
              mp.set_property("loop", "no")
          end
      end)
    '';
}
