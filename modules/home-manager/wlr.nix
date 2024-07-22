{ config, pkgs, ... }:

{
    home.file.".config/xdg-desktop-portal/sway-portal.conf".text = ''
[preferred]
default=kde
org.freedesktop.impl.portal.Screenshot=wlr
org.freedesktop.impl.portal.ScreenCast=wlr
    '';
}
