from libqtile import qtile

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

def move_window_state(window_to_update,deregister=True) :
    global window_tiling
    global window_floating
    global window_fullscreen
    if (deregister) : 
        deregister_window(window_to_update)

    if (window_to_update.fullscreen) :
        window_fullscreen.append(window_to_update)
    elif (window_to_update.floating) :
        window_floating.append(window_to_update)
    else :
        window_tiling.append(window_to_update)


#Avoid if possible, but kinda have to sometimes, you know...
def recheck_window_state() :
    global window_tiling
    global window_floating
    global window_fullscreen
    window_tiling = []
    window_floating = []
    window_fullscreen = []

    for window_obj in qtile.windows :
        move_window_state(window_obj,deregister=False)


def register_window(window_added) :
    move_window_state(window_added)
