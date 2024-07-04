from libqtile import qtile
from libqtile.backend import base
from libqtile.widget.base import _Widget
from libqtile.command.base import CommandObject
from libqtile.log_utils import logger
from libqtile.utils import send_notification

window_tiling = []
window_floating = []
window_fullscreen = []

def list_silence_remove(list_to_remove,obj) :
    try :
        list_to_remove.remove(obj)
    except ValueError :
        return False
    return True


def deregister_window(window_killed) :
    global window_tiling
    global window_floating
    global window_fullscreen
    list_silence_remove(window_tiling,window_killed)
    list_silence_remove(window_floating,window_killed)
    list_silence_remove(window_fullscreen,window_killed)

def _reorder_window_zaxis(window_list) :
    for window_index in range(len(window_list)) :
        window_list[window_index].keep_above(False)
        window_list[window_index].move_to_top()

def mark_as_latest_floating(window_obj) :
    global window_floating
    deregister_window(window_obj)
    window_floating.append(window_obj)



def reorder_window_zaxis():
    global window_tiling
    global window_floating
    global window_fullscreen
    _reorder_window_zaxis(window_tiling)
    _reorder_window_zaxis(window_floating)
    _reorder_window_zaxis(window_fullscreen)


def move_window_state(window_to_update,deregister=True,check_exists=False) :
    global window_tiling
    global window_floating
    global window_fullscreen
    window_info = window_to_update.info()

    # Exit if already in the correct spot
    if (check_exists) :
        if (window_info["fullscreen"] and window_to_update in window_fullscreen) :
            return
        elif (window_info["floating"] and window_to_update in window_floating) :
            return
        elif (((not window_info["fullscreen"]) and (not window_info["floating"])) and window_to_update in window_tiling) :
            return

    # Remove if needed
    if (deregister) : 
        deregister_window(window_to_update)

    # Put inside correct spot
    if (window_info["group"] is None) :
        return # TODO : This is bar. We need to keep bar in mind or something

    if (window_info["fullscreen"]) :
        window_fullscreen.append(window_to_update)
    elif (window_info["floating"]) :
        window_floating.append(window_to_update)
    else :
        window_tiling.append(window_to_update)

def get_all_window_obj() :
    return [
            i 
            for i in qtile.windows_map.values() 
            if not isinstance(i, (base.Internal, _Widget)) and isinstance(i, CommandObject)
    ]


#Avoid if possible, but kinda have to sometimes, you know...
def recheck_window_state() :
    for window_obj in get_all_window_obj() :
        move_window_state(window_obj,deregister=True,check_exists=True)
    reorder_window_zaxis()


def register_window(window_added) :
    move_window_state(window_added)
    reorder_window_zaxis()
