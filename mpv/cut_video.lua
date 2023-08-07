local mp = require("mp")

local start_pos = {}
local end_pos = {}

local function timestamp(duration)
	local hours = duration / 3600
	local minutes = duration % 3600 / 60
	local seconds = duration % 60
	return string.format("%02d:%02d:%02.03f", hours, minutes, seconds)
end

local function add_mark()
	local pos = mp.get_property_number("time-pos")
	if #start_pos == #end_pos then
		table.insert(start_pos, pos)
		mp.osd_message(string.format("START: %s", timestamp(pos)))
	else
		table.insert(end_pos, pos)
		mp.osd_message(string.format("END: %s", timestamp(pos)))
	end
end

local function clear_marks()
	start_pos = {}
	end_pos = {}
	mp.osd_message("Cleared marks")
end

local function create_clip()
	if #start_pos == 0 or #end_pos == 0 then
		mp.osd_message("Missing marks")
		return
	end

	if #start_pos ~= #end_pos then
		mp.osd_message("Mismatched marks")
		return
	end

	local input_path = mp.get_property("stream-path")
	local output_path = input_path:gsub(".mp4", "_clip.mp4"):gsub("/replays/", "/clips/")

	-- The final filter output will look something like this:
	--
	-- [0:1][0:2]amix=inputs=2[outa];[outa]loudnorm=I=-18:LRA=11:TP=-2[outl];
	-- [0:v]split = 3[vcopy1][vcopy2][vcopy3];
	-- [vcopy1] trim=10:20,setpts=PTS-STARTPTS[v1];
	-- [vcopy2] trim=30:40,setpts=PTS-STARTPTS[v2];
	-- [vcopy3] trim=60:80,setpts=PTS-STARTPTS[v3];
	-- [0:a]asplit = 3[acopy1][acopy2][acopy3];
	-- [acopy1] atrim=10:20,asetpts=PTS-STARTPTS[a1];
	-- [acopy2] atrim=30:40,asetpts=PTS-STARTPTS[a2];
	-- [acopy3] atrim=60:80,asetpts=PTS-STARTPTS[a3];
	-- [v1] [a1] [v2] [a2] [v3] [a3] concat=n=3:v=1:a=1[v][a]

	-- merge audio inputs 1 and 2, normalize to -18 LUFS with range 11db and true peak -2dbfs
	local filter = "[0:1][0:2]amix=inputs=2[outa];[outa]loudnorm=I=-20:LRA=13:TP=-1[outl];"

	-- split the video into N copies, where N is the number of
	-- clip segments
	filter = filter .. "[0:v]split=" .. #start_pos
	for i, _ in pairs(start_pos) do
		filter = filter .. "[vcopy" .. i .. "]"
	end

	filter = filter .. ";"

	-- trim each copy of the video to the start and end positions that were
	-- selected with the keyboard shortcuts
	for i, k in pairs(start_pos) do
		-- [vcopy<i>]trim=start=<start>:end=<end>,setpts=PTS-STARTPTS[v<i>]
		filter = filter
			.. "[vcopy"
			.. i
			.. "]trim=start="
			.. k
			.. ":end="
			.. end_pos[i]
			.. ",setpts=PTS-STARTPTS[v"
			.. i
			.. "];"
	end

	-- split the normalized audio into N copies, where N is the number
	-- of clip segments
	filter = filter .. "[outl]asplit=" .. #start_pos
	for i, _ in pairs(start_pos) do
		filter = filter .. "[acopy" .. i .. "]"
	end

	filter = filter .. ";"

	-- trim each copy of the audio to the start and end positions that were
	-- selected with the keyboard shortcuts
	for i, k in pairs(start_pos) do
		-- [acopy<i>]atrim=start=<start>:end=<end>,asetpts=PTS-STARTPTS[a<i>]
		filter = filter
			.. "[acopy"
			.. i
			.. "]atrim=start="
			.. k
			.. ":end="
			.. end_pos[i]
			.. ",asetpts=PTS-STARTPTS[a"
			.. i
			.. "];"
	end

	-- combine all the trimmed copies of video and audio into a
	-- single video/audio stream
	for i, _ in pairs(start_pos) do
		filter = filter .. "[v" .. i .. "]" .. "[a" .. i .. "]"
	end

	filter = filter .. "concat=n=" .. #start_pos .. ":v=1:a=1[v][a]"

	-- stylua: ignore
	local cmd = {
		"ffmpeg",
		"-i",              input_path,

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

		-- apply our generated filter_complex parameter to normalize
		-- the audio and clip up the video
		"-filter_complex", filter,

		-- select the clipped up and normalized video/audio that we made
		-- with the filter_complex parameter
		"-map",            "[v]",
		"-map",            "[a]",

		-- output path
		output_path,

		-- overwrite output file if already exists
		"-y",
	}

	mp.osd_message("Rendering clip...", 900)
	mp.set_property("pause", "yes")

	mp.command_native_async({ name = "subprocess", args = cmd, capture_stdout = false }, function(success, _, error)
		if success == true then
			mp.osd_message("Rendering clip complete", 30)
			mp.set_property("pause", "no")
		else
			mp.osd_message(string.format("Rendering failed: %s", error), 30)
		end
	end)
end

mp.add_key_binding("c", add_mark)
mp.add_key_binding("C", create_clip)
mp.add_key_binding("b", clear_marks)
