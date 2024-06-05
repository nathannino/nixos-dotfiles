# Note : This module will be abandonned as long as I don't need a specific pip package.
# This is broken anyways lol

{lib, config, pkgs, ...}:

{
    config = {

        environment.systemPackages = with pkgs; [
            (let
                my-python-packages = pythonPackages: with pythonPackages; [
                   #pip_install_test
		   dbus_python
		   pygobject3
		   jedi-language-server
                ];
                python-with-my-packages = python3.withPackages my-python-packages;
            in
                python-with-my-packages
		python311Packages.dbus-python
            )
        ];

    };
}
