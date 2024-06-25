from libqtile import hook, qtile
from libqtile.utils import send_notification
from commons.eww import eww_update_groups, eww_update_screens, eww_reinit_process, eww_show_layout
import subprocess, shutil, os, signal, threading

#updates

#hooks

# Fired if the screen with focus changes
# @hook.subscribe.current_screen_change # Check if duplicated by setgroup... probably is
# def hooks_screen_change():
#     eww_update_groups()

# Fired if 1) screen changes to a new group 2) when 2 groups are switched 3) when a screen is focused
@hook.subscribe.setgroup
def hooks_set_group():
    eww_update_groups()
    eww_update_screens()

@hook.subscribe.layout_change
def layout_changed(layout, group):
    eww_update_groups()
    eww_show_layout(layout, group)

# Self explanatory
@hook.subscribe.client_managed
def client_managed(_client) :
    eww_update_groups()

# Self explanatory
@hook.subscribe.client_killed
def client_killed(_client) :
    eww_update_groups()

# Self explanatory
@hook.subscribe.client_name_updated
def client_name_updated(_client):
    eww_update_groups()

@hook.subscribe.startup_complete
def startup_complete():
    eww_reinit_process()
    eww_update_screens()


notificationsdaemon = None
networkmanager_applet = None
compositor_process = None

def shutdown_process(popen, terminate) :
    if (popen is None) :
        return

    if (popen.poll() is None) :
        if (terminate) :
            popen.terminate()
        else :
            popen.kill()
        popen.wait()

def shutdown_processgroup(popen, terminate) :
    if (popen is None) :
        return

    if (popen.poll() is None) :
        if (terminate) :
            os.killpg(os.getpgid(popen.pid), signal.SIGTERM)
        else :
            os.killpg(os.getpgid(popen.pid), signal.SIGKILL)


@hook.subscribe.shutdown
def shutdown_qtile():
    #print("noop")
    global notificationsdaemon
    global networkmanager_applet
    global compositor_process

    shutdown_process(notificationsdaemon, true)
    shutdown_process(networkmanager_applet, true)
    shutdown_process(compositor_process, true)

def open_process(program_name_arguments):
    subprocess.run(program_name_arguments)

def open_process_thread(program_name_arguments):
    program_thread = threading.Thread(target=open_process,args=(program_name_arguments))
    program_thread.start()

@hook.subscribe.startup_once
def startup_once():
        global notificationsdaemon
        global networkmanager_applet
        global compositor_process

        if (qtile.core.name == "x11"):
            compositor_process = subprocess.Popen([shutil.which("picom")])
            # open_process_thread([shutil.which("picom")])
        else :
            print("unsupported") # Replace with something idk

        # subprocess.Popen("dunst")
        notificationsdaemon = subprocess.Popen(shutil.which("n-customnotif"))
        # open_process_thread([shutil.which("n-customnotif")])
        networkmanager_applet = subprocess.Popen([shutil.which("nm-applet"),"--indicator"])
        # open_process_thread([shutil.which("nm-applet"),"--indicator"])
