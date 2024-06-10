from libqtile import qtile
import subprocess, json

# Seperated for better reuse

def eww_show_layout(_layout, _group):
    subprocess.run("eww update showlayout=true", shell=True)
    sleep(3) # Um... is that bad?
    subprocess.run("eww update showlayout=false", shell=True)


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
