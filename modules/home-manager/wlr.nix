{ config, pkgs, ... }:

{
    home.file.".config/xdg-desktop-portal/sway-portal.conf".text = ''
[preferred]
default=gtk
org.freedesktop.impl.portal.Screenshot=wlr
org.freedesktop.impl.portal.ScreenCast=wlr
    '';
}
