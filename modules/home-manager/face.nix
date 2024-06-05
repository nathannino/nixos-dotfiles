{ config, pkgs, ... }:

{
    home.file = {
        ".face".source = ./../../assets/NewLogo/LogoN.png;
        ".face.icon".source = ./../../assets/NewLogo/LogoN.png;
    };
}
