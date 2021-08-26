-- Author: donmaiq
-- Appends url from clipboard to the playlist
-- Requires xclip

-- detect_platform() and get_clipboard() copied and edited from:
    -- https://github.com/rossy/mpv-repl
    -- © 2016, James Ross-Gowan
    --
    -- Permission to use, copy, modify, and/or distribute this software for any
    -- purpose with or without fee is hereby granted, provided that the above
    -- copyright notice and this permission notice appear in all copies.

local utils = require 'mp.utils'
local msg = require 'mp.msg'

--main function
function append(primaryselect)
  local args = { 'xclip', '-selection', primary and 'primary' or 'clipboard', '-out' }
  local clipboard = handleres(utils.subprocess({ args = args, cancellable = false }), args, primary)
  if clipboard then
    mp.commandv("loadfile", clipboard, "append-play")
    mp.osd_message("URL appended: "..clipboard)
    msg.info("URL appended: "..clipboard)
  end
end

--handles the subprocess response table and return clipboard if it was a success
function handleres(res, args, primary)
  if not res.error and res.status == 0 then
      return res.stdout
  else
    --if clipboard failed try primary selection
    if not primary then
      append(true)
      return nil
    end
    msg.error("There was an error getting clipboard: ")
    msg.error("  Status: "..(res.status or ""))
    msg.error("  Error: "..(res.error or ""))
    msg.error("  stdout: "..(res.stdout or ""))
    msg.error("args: "..utils.to_string(args))
    return nil
  end
end

mp.add_key_binding("ctrl+v", "appendURL", append)
