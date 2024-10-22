from libqtile import hook, qtile
from libqtile.utils import send_notification
from commons.eww import eww_update_groups, eww_update_screens, eww_reinit_process, eww_show_layout
import commons.screen, commons.window_ext
import subprocess, shutil, os, signal, threading
from libqtile.log_utils import logger

#updates
is_shutdown = False

#hooks

# Wow you don't work
@hook.subscribe.user("recheck_windows")
def recheck_windows():
    commons.window_ext.recheck_window_state()

# Fired if the screen with focus changes
# @hook.subscribe.current_screen_change # Check if duplicated by setgroup... probably is
# def hooks_screen_change():
#     eww_update_groups()

# Fired if 1) screen changes to a new group 2) when 2 groups are switched 3) when a screen is focused
@hook.subscribe.setgroup
def hooks_set_group():
    if (is_shutdown) :
        return
    eww_update_groups()
    eww_update_screens()

@hook.subscribe.float_change
def float_change():
    if (is_shutdown) :
        return
    commons.window_ext.recheck_window_state()

@hook.subscribe.layout_change
def layout_changed(layout, group):
    if (is_shutdown) :
        return
    eww_update_groups()
    eww_show_layout(layout, group)

# Self explanatory
@hook.subscribe.client_managed
def client_managed(client_window) :
    if (is_shutdown) :
        return
    commons.window_ext.register_window(client_window)
    eww_update_groups()

# Self explanatory
@hook.subscribe.client_killed
def client_killed(client_window) :
    if (is_shutdown) :
        return
    commons.window_ext.deregister_window(client_window)
    eww_update_groups()

# Self explanatory
@hook.subscribe.client_name_updated
def client_name_updated(_client):
    if (is_shutdown) :
        return
    eww_update_groups()

@hook.subscribe.client_focus
def client_focus(_client) :
    if (is_shutdown) :
        return
    eww_update_groups()

@hook.subscribe.client_new
def client_new(client) :
    return
    # TODO : only do this if x11
    #if (client.name == "Eww - mpdwindow") :
    #    client.static() #nvm, this does the same thing as setting the window type as dock, which for some reason breaks the input =D


@hook.subscribe.startup_complete
def startup_complete():
    eww_reinit_process()
    eww_update_screens()


notificationsdaemon = None
networkmanager_applet = None
compositor_process = None
waylandosd_process = None
rss_notifications = None

def shutdown_process(popen, terminate, logging_text) :
    if (popen is None) :
        logger.warning("Popen is None : " + logging_text)
        return

    if (popen.poll() is None) :
        if (terminate) :
            popen.terminate()
        else :
            popen.kill()
        popen.wait()
        logger.warning("[temp] Popen closed successfully : " + logging_text)
    else :
        logger.warning("Popen.poll() is none : " + logging_text)

def shutdown_processgroup(popen, terminate, logging_text) :
    if (popen is None) :
        logger.warning("Popen is None : " + logging_text)
        return

    if (popen.poll() is None) :
        if (terminate) :
            os.killpg(os.getpgid(popen.pid), signal.SIGTERM)
        else :
            os.killpg(os.getpgid(popen.pid), signal.SIGKILL)
    else :
        logger.warning("Popen.poll() is none : " + logging_text)


@hook.subscribe.shutdown
def shutdown_qtile():
    global is_shutdown
    is_shutdown = True
    #print("noop")
    global notificationsdaemon
    global networkmanager_applet
    global compositor_process
    global rss_notifications
    global waylandosd_process

    shutdown_process(notificationsdaemon , True , "notification")
    shutdown_process(networkmanager_applet , True , "nm-applet")
    shutdown_process(compositor_process , True , "picom")
    shutdown_process(waylandosd_process, True, "swayosd")
    shutdown_process(rss_notifications, True, "rssguard")

#def open_process(program_name_arguments):
#    subprocess.run(program_name_arguments)

#def open_process_thread(program_name_arguments):
#    program_thread = threading.Thread(target=open_process,args=(program_name_arguments))
#    program_thread.start()

@hook.subscribe.startup_once
def startup_once():
        global notificationsdaemon
        global networkmanager_applet
        global compositor_process
        global rss_notifications
        global waylandosd_process

        commons.screen.regenerate_screen_name()

        if (qtile.core.name == "x11"):
            compositor_process = subprocess.Popen([shutil.which("picom"), "--backend", "glx"])
            # open_process_thread([shutil.which("picom")])
        else :
            waylandosd_process = subprocess.Popen([shutil.which("swayosd-server")])
            print("unsupported") # Replace with something idk

        # subprocess.Popen("dunst")
        notificationsdaemon = subprocess.Popen(shutil.which("n-customnotif"))
        logger.warning("notification pid : " + str(notificationsdaemon.pid))
        # open_process_thread([shutil.which("n-customnotif")])
        networkmanager_applet = subprocess.Popen([shutil.which("nm-applet"),"--indicator"])
        rss_notifications = subprocess.Popen([shutil.which("rssguard")])
        subprocess.run([shutil.which("dbus-update-activation-environment"),"--systemd","WAYLAND_DISPLAY","XDG_CURRENT_DESKTOP=sway"])
        # open_process_thread([shutil.which("nm-applet"),"--indicator"])
