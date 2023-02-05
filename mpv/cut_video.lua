local mp = require("mp")
local utils = require("mp.utils")

local start_pos = nil
local end_pos = nil

local function timestamp(duration)
	local hours = duration / 3600
	local minutes = duration % 3600 / 60
	local seconds = duration % 60
	return string.format("%02d:%02d:%02.03f", hours, minutes, seconds)
end

function toggle_mark()
	local pos = mp.get_property_number("time-pos")
	if start_pos == nil then
		start_pos = pos
		mp.osd_message(string.format("Marked %s as start position", timestamp(pos)))
	elseif end_pos == nil then
		end_pos = pos
		mp.osd_message(string.format("Marked %s as end position", timestamp(pos)))
	else
		start_pos = nil
		end_pos = nil
		mp.osd_message("Cleared marks")
	end
end

function create_clip()
	if start_pos == nil or end_pos == nil then
		mp.osd_message("Missing marks")
		return
	end

	local input_path = mp.get_property("stream-path")
	local output_path = input_path:gsub(".mp4", "_clip.mp4"):gsub("/replays/", "/clips/")

	-- stylua: ignore
	local cmd = {
		"ffmpeg",
		"-i",              input_path,

		-- skip to start position
		"-ss",             tostring(start_pos),

		-- video codec settings
		-- https://www.nvidia.com/en-us/geforce/guides/broadcasting-guide/
		-- https://git.dec05eba.com/gpu-screen-recorder/tree/src/main.cpp#n411
		"-c:v",            "hevc_nvenc",
		"-preset",         "p6",
		"-profile",        "main",
		"-tune",           "hq",
		"-rc",             "constqp",
		"-qp",             "24",

		-- set audio settings to AAC 320 kbps
		"-c:a",            "aac",
		"-b:a",            "320k",

		 -- merge audio inputs 1 and 2, normalize to -18 LUFS with range 11db and true peak -2dbfs
		"-filter_complex", "[0:1][0:2]amerge=inputs=2[outa];[outa]loudnorm=I=-18:LRA=11:TP=-2[outl]",

		-- seek to end position
		"-to",             tostring(end_pos),

		-- map input video stream 0 to output video stream 0
		"-map",            "0:v:0",

		-- map LUFS normalized audio to output audio stream 0
		"-map",            "[outl]",

		-- output path
		output_path,

		-- overwrite output file if already exists
		"-y",
	}

	mp.osd_message("Rendering clip...", 900)
	mp.commandv("set", "pause", "yes")

	mp.command_native_async({ name = "subprocess", args = cmd, capture_stdout = false }, function(success, _, error)
		if success == true then
			mp.osd_message("Rendering clip complete", 30)
			mp.commandv("set", "pause", "no")
		else
			mp.osd_message(string.format("Rendering failed: %s", error), 30)
		end
	end)
end

mp.add_key_binding("c", toggle_mark)
mp.add_key_binding("C", create_clip)
