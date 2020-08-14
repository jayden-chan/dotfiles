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

def mousemove(x, y):
    Popen(["xdotool", "mousemove_relative", "--", str(x), str(y)])

def ProcessIRRemote(conn, mode, mmove):
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
            return mode, mmove

        # Ignore the first few additional presses after the first one
        # Basically create a key repeat delay of about ~0.3 seconds
        if (mode == "mouse" and (command == "KEY_LEFT" or command == "KEY_RIGHT" or command == "KEY_UP" or command == "KEY_DOWN")):
            if (sequence == 0):
                mmove = 10
            else:
                mmove = min(mmove + sequence * 2, 200)
        elif (sequence != 0 and sequence < 5):
            return mode, mmove

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
        elif (command == "KEY_HOME"):
            key("space")
        elif (command == "KEY_OK"):
            click(1)
        elif (command == "KEY_G"):
            key("Right")
        elif (command == "KEY_TV"):
            key("Left")
        elif (command == "BTN_MOUSE"):
            mode = "mouse" if mode == "normal" else "normal"
            mmove = 50 if mode == "normal" else 5
            print("Changing to mode " + mode)
        elif (command == "KEY_INFO"):
            key("ctrl+i")
        elif (command == "KEY_RED"):
            Popen(["xdg-open", "https://www.youtube.com"])
        elif (command == "KEY_BLUE"):
            Popen(["xdg-open", "https://www.twitch.tv/directory/following/live"])
        else:
            print(command)

    return mode, mmove

class GracefulKiller:
  kill_now = False
  def __init__(self):
    signal.signal(signal.SIGINT, self.exit_gracefully)
    signal.signal(signal.SIGTERM, self.exit_gracefully)

  def exit_gracefully(self,signum, frame):
    self.kill_now = True

if __name__ == '__main__':
    print("Starting up")
    mode = "normal"
    mmove = 50
    conn = RawConnection()
    killer = GracefulKiller()
    print("Listening for remote commands")
    while not killer.kill_now:
        mode, mmove = ProcessIRRemote(conn, mode, mmove)

    print("Exiting")
