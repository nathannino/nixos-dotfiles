import subprocess, shutil, re
from libqtile.log_utils import logger
from libqtile import hook, qtile

def regex_to_dict(regex_output) :
    regex_array = []
    for regex_entry in regex_output :
        regex_array.append({
            "index" : int(regex_entry[0]),
            "name" : str(regex_entry[1])
            })
    return regex_array

def sort_screen_dictionary_entry(dict_entry) :
    return dict_entry.index

screen_dictionary = []
def update_screen_dictionary(new_screen_dictionary):
    global screen_dictionary
    new_screen_dictionary_sorted = new_screen_dictionary.sort(key=sort_screen_dictionary_entry)
    logger.warning(str(new_screen_dictionary_sorted))
    # TODO : Check difference (i.e to kill eww bars no longer needed)

    screen_dictionary = new_screen_dictionary_sorted

def get_screen_name(index):
    global screen_dictionary
    try :
        return screen_dictionary[index]["name"]
    except IndexError :
        logger.error("Screen index \"" + str(index) + "\" not found in screen name dictionary")
        return str(index)

def regenerate_screen_name_xorg():
    xrandr_process = subprocess.run([shutil.which("xrandr"), "--listmonitors"], capture_output=True, text=True)
    xrandr_output = xrandr_process.stdout
    regex_output = re.findall(re.compile(r"^ *([0-9]+):.*?([A-z0-9-]+)$",re.MULTILINE),xrandr_output)
    update_screen_dictionary(regex_to_dict(regex_output))

def regenerate_screen_name_wayland():
    logger.error("regenerate_screen_name_wayland not implemented yet oupsies =/")

def regenerate_screen_name():
    logger.warning("regenerating screen dictionary")
    if (qtile.core.name == "x11"):
        regenerate_screen_name_xorg()
    else:
        regenerate_screen_name_wayland()
