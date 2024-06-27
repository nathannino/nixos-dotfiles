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
    groups_set = qtile.get_groups()
    group_array = []
    for group in groups_set:
        groupset = groups_set[group]

        istiled = False

        if (len(groupset['tiled_windows']) != 0) : istiled = True

        group_dict = {'name': groupset['name'],'label' : groupset['label'], 'windows' : groupset['windows'], 'focus' : groupset['focus'], 'screen' : commons.screen.get_screen_name_old_index(groupset['screen'], True), 'layout' : groupset['layout'], 'isfull' : istiled};
        group_array.append(group_dict)
    
    subprocess.run("eww update groups=\'" + json.dumps(group_array).replace("'","'\"'\"'") + "\'",shell=True)

# TODO : use new system?
def eww_update_screens():
    subprocess.run("eww update currentscreen=\'" + json.dumps(qtile.current_screen.info()) + "\'", shell=True)

def eww_generate_id(id_prefix,screenid) :
    return id_prefix + commons.screen.get_screen_name_index(screenid)

def eww_open_screen(screen) :
    logger.warning(str(screen.index))
    screen_name = commons.screen.get_screen_name_index(screen.index)
    subprocess.run("eww open topbar --screen " + screen_name + " --id " + eww_generate_id("topbar",screen.index) + " --arg barscreen=" + screen_name, shell=True)

def eww_reinit_process():
    subprocess.run("eww close-all", shell=True)
    for index, screen in enumerate(qtile.screens) :
        eww_open_screen(screen)
    eww_update_groups()
