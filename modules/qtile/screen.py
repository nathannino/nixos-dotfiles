import subprocess, shutil, re
from libqtile.log_utils import logger
from libqtile import hook, qtile
import commons.eww

def regex_to_dict(regex_output) :
    regex_array = []
    for regex_entry in regex_output :
        regex_array.append({
            "index" : int(regex_entry[0]),
            "x" : int(regex_entry[1]),
            "y" : int(regex_entry[2]),
            "name" : str(regex_entry[3])
            })
    return regex_array

def sort_screen_dictionary_entry(dict_entry) :
    return dict_entry["index"]

screen_dictionary = []
def update_screen_dictionary(new_screen_dictionary):
    global screen_dictionary
    new_screen_dictionary.sort(key=sort_screen_dictionary_entry)
    logger.warning(str(new_screen_dictionary))
    # TODO : Check difference (i.e to kill eww bars no longer needed)

    screen_dictionary = new_screen_dictionary

def get_screen_name_index(index) :
    global screen_dictionary
    return screen_dictionary[index]["name"]

def attempt_screen_translation(screenobj) :
    global screen_dictionary
    for screen_dict_entry in screen_dictionary :
        if (screen_dict_entry["x"] == screenobj["x"] and screen_dict_entry["y"] == screenobj["y"]) :
            return screen_dict_entry["name"]
    logger.error("Screen (x:" + screenobj["x"] + "y:" + screenobj["y"] + ") could not be matched")
    return screenobj["index"]

def get_screen_name(screenobj,ignoreother):
    global screen_dictionary

    if (index is None) :
        if (ignoreother) :
            return index
        else :
            logger.error("Screen index is not an integer")
            raise TypeError

    try :
        return attempt_screen_translation(screenobj)
    except TypeError :
        if (ignoreother) :
            return index
        else :
            logger.error("Screen index is not an integer")
            raise

def get_screen_name_old_index(screen_oldindex,ignoreother) :
    if (screen_oldindex is None) :
        if (ignoreother) :
            return screen_oldindex
        else :
            logger.error("Screen index is not an integer")
            raise TypeError
    screen_array = qtile.get_screens()
    return get_screen_name(screen_array[screen_oldindex],ignoreother)


def regenerate_screen_name_xorg():
    xrandr_process = subprocess.run([shutil.which("xrandr"), "--listmonitors"], capture_output=True, text=True)
    xrandr_output = xrandr_process.stdout
    regex_output = re.findall(re.compile(r"^ *([0-9]+):.*?\+([0-9]+)\+([0-9]+) +([A-z0-9-]+)$",re.MULTILINE),xrandr_output)
    update_screen_dictionary(regex_to_dict(regex_output))

def regenerate_screen_name_wayland():
    logger.error("regenerate_screen_name_wayland not implemented yet oupsies =/")

def regenerate_screen_name():
    logger.warning("regenerating screen dictionary")
    if (qtile.core.name == "x11"):
        regenerate_screen_name_xorg()
    else:
        regenerate_screen_name_wayland()

@hook.subscribe.screens_reconfigured
def screen_reconf():
    logger.warning("screen reconf event")
    regenerate_screen_name()
    commons.eww.eww_update_groups

