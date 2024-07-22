from libqtile import qtile
from libqtile.log_utils import logger
import subprocess, json
import time
import threading
import commons.screen

# Seperated for better reuse

def eww_show_layout_thread(_layout,_group,thnum):
    time.sleep(0.1)
    subprocess.run("eww update showlayout=true", shell=True)
    time.sleep(3) # Um... is that bad?
    global thread_number
    if (thnum == thread_number) :
        subprocess.run("eww update showlayout=false", shell=True)
        thread_number = 0

thread_number = 0

def eww_show_layout(_layout, _group):
    global thread_number
    thread_number = thread_number + 1
    thread = threading.Thread(target=eww_show_layout_thread, args=(_layout,_group,thread_number))
    thread.start()


def eww_update_groups():
    groups_obj = qtile.groups
    group_array = []
    for group in groups_obj:
        group_info = group.info()
        istiled = False

        if (len(group_info['tiled_windows']) != 0) : 
            if (not group.current_window.info().get("fullscreen",False)) :
                istiled = True

        group_dict = {'name': group_info['name'],'label' : group_info['label'], 'windows' : group_info['windows'], 'focus' : group_info['focus'], 'screen' : str(commons.screen.get_screen_name_old_index(group_info['screen'], True)), 'layout' : group_info['layout'], 'isfull' : istiled};
        group_array.append(group_dict)
    
    subprocess.run("eww update groups=\'" + json.dumps(group_array).replace("'","'\"'\"'") + "\'",shell=True)

# TODO : use new system?
def eww_update_screens():
    subprocess.run("eww update currentscreen=\'" + str(commons.screen.get_screen_name(qtile.current_screen.info(), False)) + "\'", shell=True)

def eww_generate_id(id_prefix,screenid) :
    try :
        return id_prefix + commons.screen.get_screen_name_index(screenid)
    except IndexError :
        return id_prefix + str(screenid)

def eww_open_screen(screen) :
    logger.warning(str(screen.index))
    screen_name = ""
    try :
        screen_name = commons.screen.get_screen_name_index(screen.index)
    except IndexError :
        screen_name = str(screen.index)
        logger.warning("Screen index is bad")

    topbarname = "topbarxorg"
    if (qtile.core.name == "wayland") :
        topbarname = "topbarwayland"

    subprocess.run("eww open " + topbarname + " --screen " + screen_name + " --id " + eww_generate_id("topbar",screen.index) + " --arg barscreen=" + screen_name, shell=True)

def eww_reinit_process():
    subprocess.run("eww close-all", shell=True)
    for index, screen in enumerate(qtile.screens) :
        eww_open_screen(screen)
    eww_update_groups()

    qtilecore = "xorg"
    if (qtile.core.name == "wayland") :
        qtilecore = "wayland"
    subprocess.run("eww update qtilecore=" + qtilecore, shell=True)
