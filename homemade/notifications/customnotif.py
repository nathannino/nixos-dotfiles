#!/usr/bin/env python3

import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib
import threading
import time
import json
import sys
import signal
import atexit
import os
import subprocess
import re

pipe_dir = os.environ['XDG_RUNTIME_DIR']; # Potential to throw an error TODO : Try catch or something idk
pipe_input_file = pipe_dir + "/customnotif-input"
pipe_output_file = pipe_dir + "/customnotif-output"

def setup_pipe():
    try :
        os.mkfifo(pipe_input_file)
    except FileExistsError :
        os.remove(pipe_input_file)
        os.mkfifo(pipe_input_file)
    while True:
        with open(pipe_input_file, "r") as pipe:
            for line in pipe:
                print(line)


def exit_handler():
    print("Goodbye pipe")
    os.remove(pipe_input_file)
    os.remove(pipe_output_file)

def kill_handler(*args):
    sys.exit(0)


escapechars=r'([\n\t\r\b\f])'

class Notification:
    def __init__(self, app_name, summary, body, icon): # I don't know why I am keeping the non-json part tbh
        self.app_name = app_name
        self.summary = summary
        self.body = body
        self.icon = icon # TODO : Generate icon for programs with icon data in hints
        self.json = {
                "app_name"  : app_name,
                "summary"   : summary,
                "body"      : body,
                "icon"      : icon
        }
        self.jsonticker = {
                "app_name"  : app_name.encode('unicode_escape').decode().replace("\\","⧹"),
                "summary"   : summary.encode('unicode_escape').decode().replace("\\","⧹"),
                "body"      : body.encode('unicode_escape').decode().replace("\\","⧹"),
        }

notifications_popup = []
notifications = []
notification_ticker_int = 0
notification_ticker_name = ["notificationone","notificationtwo"]

no_new_threads = False

def start_thread():
    global no_new_threads
    if (no_new_threads):
        return
    send_ticker()
    if (len(notifications_popup) != 0):
        timer_thread = threading.Thread(target=wait_object,)
        timer_thread.start()

def remove_object():
    notifications_popup.pop(0)
    start_thread()


def wait_object():
    global no_new_threads
    no_new_threads = True
    time.sleep(8)
    no_new_threads = False
    remove_object()


def add_object(notif):
    notifications_popup.append(notif.jsonticker)
    notifications.append(notif.json)
    start_thread()
    print_state()

def print_state():
    with open(pipe_output_file, "w") as pipe:
        pipe.write(json.dumps(notifications))

# TODO :
# [X] Make notification ticker switch between 2 notifications with an animation
# [ ] Escape special characters
def send_ticker():
    global notification_ticker_int
    global notifications_popup
    notification_ticker_int ^= 1
    if (len(notifications_popup) <= 0) :
        subprocess.run("eww update notificationticker=false", shell=True)
        return
    
    subprocess.run("eww update notificationticker=true", shell=True)

    print(json.dumps(notifications_popup[0]))

    subprocess.run("eww update notificationtickerint="+str(notification_ticker_int), shell=True)
    subprocess.run("eww update " + notification_ticker_name[notification_ticker_int] + "=\'" + json.dumps(notifications_popup[0]) +"\'", shell=True)



#def print_state():
#
#    string = ""
#    for item in notifications:
#        string = string + f"""
#                  (button :class 'notif'
#                   (box :orientation 'horizontal' :space-evenly false
#                      (image :image-width 80 :image-height 80 :path '{item.icon or ''}')
#                      (box :orientation 'vertical'
#                        (label :width 100 :wrap true :text '{item.summary or ''}')
#                        (label :width 100 :wrap true :text '{item.body or ''}')
#                  )))
#                  """
#    string = string.replace('\n', ' ')
#    print(fr"""(box :orientation 'vertical' {string or ''})""", flush=True)

# def print_state():
#     string = ""
#     for item in notifications:
#         string = string + f"{item}"
#     print(string, flush=True)

class NotificationServer(dbus.service.Object):
    def __init__(self):
        bus_name = dbus.service.BusName('org.freedesktop.Notifications', bus=dbus.SessionBus())
        dbus.service.Object.__init__(self, bus_name, '/org/freedesktop/Notifications')

    @dbus.service.method('org.freedesktop.Notifications', in_signature='susssasa{ss}i', out_signature='u')
    def Notify(self, app_name, replaces_id, app_icon, summary, body, actions, hints, timeout):
        #print("Received Notification:")
        #print("  App Name:", app_name)
        #print("  Replaces ID:", replaces_id)
        #print("  App Icon:", app_icon)
        #print("  Summary:", summary)
        #print("  Body:", body)
        #print("  Actions:", actions)
        # print("  Hints:", hints) # TODO : Parse image data when required : Discord most likely
        #print("  Timeout:", timeout)
        #print("Hi!")
        add_object(Notification(app_name, summary, body, app_icon))
        return 0

    @dbus.service.method('org.freedesktop.Notifications', out_signature='ssss')
    def GetServerInformation(self):
        return ("Custom Notification Server", "ExampleNS", "1.0", "1.2")

DBusGMainLoop(set_as_default=True)

def setup_pipe_thread():
    print("testing")
    thread = threading.Thread(target=setup_pipe)
    thread.start()

def setup_output_pipe():
    try :
        os.mkfifo(pipe_output_file)
    except FileExistsError :
        os.remove(pipe_output_file)
        os.mkfifo(pipe_output_file)

if __name__ == '__main__':
    atexit.register(exit_handler)
    signal.signal(signal.SIGINT, kill_handler)
    signal.signal(signal.SIGTERM, kill_handler)
    setup_output_pipe()
    server = NotificationServer()
    setup_pipe_thread()
    mainloop = GLib.MainLoop()
    mainloop.run()