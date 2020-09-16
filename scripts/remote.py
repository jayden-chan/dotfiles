#!/usr/bin/python3
from lirc import RawConnection
from time import sleep
from subprocess import run, Popen
import signal
import time

def key(code):
    Popen(["xdotool", "key", code])

def keys(keys):
    Popen(["xdotool", "key"] + keys)

def click(btn):
    Popen(["xdotool", "click", str(btn)])

def scroll(direction):
    if (direction == "down"):
        Popen(["xdotool", "click", "5", "5", "5", "5", "5"])
    else:
        Popen(["xdotool", "click", "4", "4", "4", "4", "4"])

def mousejump(x, y):
    Popen(["xdotool", "mousemove", "--", str(x), str(y)])

def mousemove(x, y):
    Popen(["xdotool", "mousemove_relative", "--", str(x), str(y)])

def notify(title, message, icon):
    Popen(["notify-send", title, message, "-i", icon, "-t", "3000"])

def ProcessIRRemote(conn, mmove):
    #keypress format = (hexcode, repeat_num, command_key, remote_id)
    try:
        keypress = conn.readline(.0001)
    except:
        keypress=""

    if (keypress != "" and keypress != None):
        data = keypress.split()
        sequence = int(data[1], 16)
        command = data[2]
        remote_id = data[3]

        # Ignore remotes that we don't care about
        if (remote_id != "XR4000"):
            return mmove

        # Ignore the first few additional presses after the first one
        # Basically create a key repeat delay of about ~0.3 seconds
        if (sequence != 0 and sequence < 5):
            return mmove

        if (command == "KEY_LEFT"):
            mousemove(-mmove, 0)
        elif (command == "KEY_RIGHT"):
            mousemove(mmove, 0)
        elif (command == "KEY_UP"):
            mousemove(0, -mmove)
        elif (command == "KEY_DOWN"):
            mousemove(0, mmove)
        elif (command == "KEY_VOD"):
            click(3)
        elif (command == "KEY_TV2"):
            # Need to use the synchronous version here
            run(["xdotool", "key", "Down", "Down", "Down", "Down", "Down", "Down", "Down"])
            run(["xdotool", "key", "Return"])
            Popen(["yt"])
        elif (command == "KEY_PVR"):
            # Need to use the synchronous version here
            run(["xdotool", "key", "Down", "Down", "Down", "Down", "Down", "Down", "Down"])
            run(["xdotool", "key", "Return"])
            Popen(["ttv"])
        elif (command == "KEY_STOP"):
            key("ctrl+q");
        elif (command == "KEY_MENU"):
            key("alt+Tab")
        elif (command == "KEY_PLAYPAUSE"):
            key("space")
        elif (command == "KEY_VOLUMEUP"):
            key("Up")
        elif (command == "KEY_VOLUMEDOWN"):
            key("Down")
        elif (command == "KEY_CHANNELUP"):
            run(["xdotool", "click", "4"])
            run(["xdotool", "click", "4"])
            run(["xdotool", "click", "4"])
            run(["xdotool", "click", "4"])
            run(["xdotool", "click", "4"])
        elif (command == "KEY_CHANNELDOWN"):
            run(["xdotool", "click", "5"])
            run(["xdotool", "click", "5"])
            run(["xdotool", "click", "5"])
            run(["xdotool", "click", "5"])
            run(["xdotool", "click", "5"])
        elif (command == "BTN_1"):
            mousejump(531, 445)
        elif (command == "BTN_2"):
            mousejump(915, 445)
        elif (command == "BTN_3"):
            mousejump(1312, 445)
        elif (command == "BTN_4"):
            mousejump(1700, 445)
        elif (command == "KEY_PAGEUP"):
            key("Page_Up")
        elif (command == "KEY_PAGEDOWN"):
            key("Page_Down")
        elif (command == "KEY_FASTFORWARD"):
            key("n")
        elif (command == "KEY_REWIND"):
            key("p")
        elif (command == "KEY_MUTE"):
            key("m")
        elif (command == "KEY_HOME"):
            key("space")
        elif (command == "KEY_OK"):
            click(1)
        elif (command == "KEY_G"):
            key("Right")
        elif (command == "KEY_BACK"):
            key("f")
        elif (command == "KEY_LAST"):
            key("BackSpace")
        elif (command == "KEY_TV"):
            key("Left")
        elif (command == "KEY_INFO"):
            if (mmove == 10):
                mmove = 100
            else:
                mmove = 10
        elif (command == "KEY_RED"):
            Popen(["xdg-open", "https://www.youtube.com"])
        elif (command == "KEY_BLUE"):
            Popen(["xdg-open", "https://www.twitch.tv/directory/following/live"])
        elif (command == "KEY_POWER"):
            with open("/tmp/yt_shutdown", "r+") as f:
                contents = f.read()
                f.seek(0)
                if (contents == "yes"):
                    f.write("no")
                    notify("remote.py", "Shutdown cancelled", "display");
                else:
                    f.write("yes")
                    notify("remote.py", "Projector will shutdown after video ends", "display");
                f.truncate()
        else:
            print(command)

    return mmove

class GracefulKiller:
  kill_now = False
  def __init__(self):
    signal.signal(signal.SIGINT, self.exit_gracefully)
    signal.signal(signal.SIGTERM, self.exit_gracefully)

  def exit_gracefully(self,signum, frame):
    self.kill_now = True

if __name__ == '__main__':
    print("Starting up")
    mmove = 50
    conn = RawConnection()
    killer = GracefulKiller()
    print("Listening for remote commands")
    while not killer.kill_now:
        mmove = ProcessIRRemote(conn, mmove)

    print("Exiting")
