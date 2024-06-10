from libqtile import qtile
import subprocess, json
import time
import threading

# Seperated for better reuse

def eww_show_layout_thread(_layout,_group,thnum):
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
        group_dict = {'name': groupset['name'],'label' : groupset['label'], 'windows' : groupset['windows'], 'focus' : groupset['focus'], 'screen' : groupset['screen'], 'layout' : groupset['layout']};
        group_array.append(group_dict)
    
    subprocess.run("eww update groups=\'" + json.dumps(group_array) + "\'",shell=True)

def eww_update_screens():
    subprocess.run("eww update currentscreen=\'" + json.dumps(qtile.current_screen.info()) + "\'", shell=True)

def eww_open_screen(index) :
    subprocess.run("eww open topbar --screen " + str(index) + " --id topbar" + str(index), shell=True)

def eww_reinit_process():
    subprocess.run("eww close-all", shell=True)
    for index, screen in enumerate(qtile.screens) :
        eww_open_screen(index)
