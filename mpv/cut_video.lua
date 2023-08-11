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
	local shell_cmd = "bun run $DOT/mpv/cut_video.ts '" .. input_path .. "' "
	for i, k in pairs(start_pos) do
		shell_cmd = shell_cmd .. "'" .. k .. "' "
		shell_cmd = shell_cmd .. "'" .. end_pos[i] .. "' "
	end

	local cmd = { "zsh", "-c", shell_cmd }

	mp.osd_message("Rendering clip...", 900)
	mp.set_property("pause", "yes")

	mp.command_native_async({ name = "subprocess", args = cmd, capture_stdout = false }, function(success, _, error)
		if success == true then
			mp.osd_message("Rendering clip complete", 30)
		else
			mp.osd_message(string.format("Rendering failed: %s", error), 30)
		end
	end)
end

mp.add_key_binding("c", add_mark)
mp.add_key_binding("C", create_clip)
mp.add_key_binding("b", clear_marks)
