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
import os.path
import subprocess
import re
import queue
import textwrap
import datetime
import uuid
import png
import shutil


notifications_popup = []
notifications = []
notification_ticker_int = 0
notification_ticker_name = ["notificationone","notificationtwo"]

unread = "0"

homedir = os.environ['HOME']
filedir = homedir+"/.cache/ncustomnotif"

pipe_dir = os.environ['XDG_RUNTIME_DIR']; # Potential to throw an error TODO : Try catch or something idk
pipe_input_file = pipe_dir + "/customnotif-input"
pipe_output_file = pipe_dir + "/customnotif-output"


def setup_filedir():
    if (os.path.isdir(filedir)) :
        shutil.rmtree(filedir)
    elif (os.path.exists(filedir)) :
        raise Exception
    os.makedirs(filedir)

def setunread(newunread):
    global unread
    unread = newunread
    subprocess.run("eww update \'notificationunread=" + unread + "\'", shell=True)

def resetunread():
    setunread("0")

def incrementunread():
    global unread
    if (unread == "9+" or unread == "NaN"):
        return
    if (unread == "9"):
        setunread("9+")
        return
    try :
        setunread(str(int(unread)+1))
    except ValueError:
        setunread("NaN")

def removefile(fileuuid):
    notiffilepath = filedir+"/"+fileuuid+".png"
    if (os.path.isfile(notiffilepath)) :
        os.remove(notiffilepath)

def setup_pipe():
    global notifications
    try :
        os.mkfifo(pipe_input_file)
    except FileExistsError :
        os.remove(pipe_input_file)
        os.mkfifo(pipe_input_file)
    while True:
        with open(pipe_input_file, "r") as pipe:
            for line in pipe:
                try :
                    command = line.split()
                    match command[0]:
                        case "clear-all" :
                            notifications = []
                            setup_filedir()
                            print_state()
                        case "refresh" :
                            print_state()
                        case "read" :
                            resetunread()
                        case "clear" :
                            notifuuid = command[1]
                            notifications = list(filter(lambda noti: noti["uuid"] != notifuuid,notifications))
                            removefile(notifuuid)
                            print_state()

                
                except IndexError:
                    print("Invalid format oh no :shrug:") # We won't see this, it's just to make sure nothing crashes.


def exit_handler():
    print("Goodbye pipe")
    os.remove(pipe_input_file)
    os.remove(pipe_output_file)

def kill_handler(*args):
    sys.exit(0)


escapechars=r'([\n\t\r\b\f])'

app_title_max_length = 50
summary_max_length = 50
body_max_length = 100
body_max_length_image = 75

class Notification:
    def __init__(self, app_name, summary, body, icon, uuidstr): # I don't know why I am keeping the non-json part tbh
        true_body_max_length = body_max_length
        if (icon is not None) :
            true_body_max_length = body_max_length_image
        self.json = {
                "app_name"  : "\n".join(textwrap.wrap(app_name,width=app_title_max_length)),
                "summary"   : "\n".join(textwrap.wrap(summary,width=summary_max_length)),
                "body"      : "\n".join(textwrap.wrap(body,width=true_body_max_length)),
                "timestamp" : "{:%Y-%b-%d %H:%M}".format(datetime.datetime.now()),
                "icon"      : icon,
                "uuid"      : uuidstr
        }
        self.jsonticker = {
                "app_name"  : app_name.encode('unicode_escape').decode().replace("\\","⧹"),
                "summary"   : summary.encode('unicode_escape').decode().replace("\\","⧹"),
                "body"      : body.encode('unicode_escape').decode().replace("\\","⧹"),
        }

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
    notifications.insert(0,notif.json)
    start_thread()
    print_state()
    incrementunread()


# This used to be a named pipe, but was too unreliable. Why didn't I think of just running eww update lol. The logic should still work with a queue, but the right thing to do would be to... TODO : Remove queue and thread
def print_state():
    print("printstate")
    returnvalue = subprocess.run("eww update notifs=\'"+json.dumps(notifications).replace("'","'\"'\"'")+"\'", shell=True, encoding="utf-8")
    print(returnvalue.stdout)

# TODO :
# [X] Make notification ticker switch between 2 notifications with an animation
# [?] Escape special characters
def send_ticker():
    global notification_ticker_int
    global notifications_popup
    notification_ticker_int ^= 1
    if (len(notifications_popup) <= 0) :
        subprocess.run("eww update notificationticker=false", shell=True)
        return
    
    subprocess.run("eww update notificationticker=true", shell=True)

    subprocess.run("eww update notificationtickerint="+str(notification_ticker_int), shell=True)
    subprocess.run("eww update " + notification_ticker_name[notification_ticker_int] + "=\'" + json.dumps(notifications_popup[0]).replace("'","'\"'\"'") +"\'", shell=True)



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
#     string = "".replace("'","'\"'\"'")
#     for item in notifications:
#         string = string + f"{item}"
#     print(string, flush=True)


# =========[ Image generation =D ]============

# [ I don't know what the license for this piece of text is, but it came from https://specifications.freedesktop.org/notification-spec/notification-spec-latest.html ] (2024-06-17)
# The "image-data" and "icon-data" hints should be a DBus structure of signature iiibiiay. The components of this structure are as follows dbus.Struct(
# 1. width : Width of the image in pixels (Ex : dbus.Int32(160))
# 2. height : Height of the image in pixels (Ex: dbus.Int32(160))
# 3. rowstride : Distance in bytes between row starts (Ex: dbus.Int32(640))
# 4. has_alpha : Whether the image has an alpha channel (Ex: dbus.Boolean(True))
# 5. bits_per_sample : Must always be 8 (Ex: dbus.Int32(8))
# 6. channels : if has_alpha is True, must be 4, otherwise 3 (Ex: dbus.Int32(4))
# 7. data : The image data, in RGB byte order (dbus.Array([dbus.Byte(90)...]))
# )

# As for us, we are going to generate a png file using pypng. We are going to do it as badly as needed, because this is meant for me alone tbh, so it can be as spagetti code as needed ;)
def generateimage(imagedata, uuid):
    if (len(imagedata) == 7) :
        if (int(imagedata[4]) != 8):
            print("bad bits")
            return None
        width = int(imagedata[0])
        height = int(imagedata[1])
        rowstride = int(imagedata[2])
        has_alpha = bool(imagedata[3])
        pngmode = "RGB"
        if (has_alpha) :
            pngmode = "RGBA"
        if ((has_alpha and int(imagedata[5]) != 4) or (not has_alpha and int(imagedata[5]) != 3)):
            print("bad channel")
            return None
        try :
            imagedataarray = []
            for x in range(height) :
                imagedataarraytwo = []
                for y in range(rowstride) :
                    byteindex = x*rowstride+y
                    imagedataarraytwo.append(imagedata[6][byteindex])
                imagedataarray.append(imagedataarraytwo)
            pngpathfile = filedir + "/" + uuid + ".png"

            png.from_array(imagedataarray,mode=pngmode,info={"bitdepth":8}).save(pngpathfile)
            return pngpathfile
        except Exception as e :
            print(str(e)) # It's horrible, but I would rather have the exception be printed on my console then it being sent back to the notification
    else :
        print("Bad image data")
    return None

# ============================================

class NotificationServer(dbus.service.Object):
    def __init__(self):
        bus_name = dbus.service.BusName('org.freedesktop.Notifications', bus=dbus.SessionBus())
        dbus.service.Object.__init__(self, bus_name, '/org/freedesktop/Notifications')

    @dbus.service.method('org.freedesktop.Notifications', in_signature='susssasa{ss}i', out_signature='u')
    def Notify(self, app_name, replaces_id, app_icon, summary, body, actions, hints, timeout):
        #print("Received Notification:")
        #print("  App Name:", app_name)
        #print("  Replaces ID:", replaces_id)
        #print("  Summary:", summary)
        #print("  Body:", body)
        #print("  Actions:", actions)
        # print("  Hints:", hints) # TODO : Parse image data when required : Discord most likely
        #print("  sender-pid: " + str(hints.get("sender-pid")))
        #print("  Timeout:", timeout)
        #print("Hi!")
        app_icon_true = None
        notifssh = str(uuid.uuid1())
        if (os.path.isfile(app_icon)) :
            app_icon_true = app_icon
        else :
            imagedata = hints.get("image-data")
            if (imagedata is not None) :
                app_icon_true = generateimage(imagedata, notifssh)
            else :
                print("no images")

        add_object(Notification(app_name, summary, body, app_icon_true, notifssh))
        return 0

    @dbus.service.method('org.freedesktop.Notifications', out_signature='ssss')
    def GetServerInformation(self):
        return ("Custom Notification Server", "ExampleNS", "1.0", "1.2")

DBusGMainLoop(set_as_default=True)

def setup_pipe_thread():
    thread = threading.Thread(target=setup_pipe)
    thread.start()

def setup_output_pipe():
    try :
        os.mkfifo(pipe_output_file)
    except FileExistsError :
        os.remove(pipe_output_file)
        os.mkfifo(pipe_output_file)


if __name__ == '__main__':
    setup_filedir()
    atexit.register(exit_handler)
    signal.signal(signal.SIGINT, kill_handler)
    signal.signal(signal.SIGTERM, kill_handler)
    setup_output_pipe()
    output_thread = threading.Thread(target=print_state,)
    output_thread.start()
    server = NotificationServer()
    setup_pipe_thread()
    mainloop = GLib.MainLoop()
    mainloop.run()
