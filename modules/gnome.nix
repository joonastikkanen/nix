{ config, pkgs, ... }:

{
    services.xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
        layout = "fi";
        xkbVariant = "";
        libinput = {
        enable = true;

        # disabling mouse acceleration
        mouse = {
            accelProfile = "flat";
        };
        };

        excludePackages = with pkgs; [
            xterm
        ];
    };
    environment.systemPackages = with pkgs; [
        gnomeExtensions.appindicator
        gnomeExtensions.sound-output-device-chooser
        gnomeExtensions.user-themes
        gnomeExtensions.vitals
        gnomeExtensions.blur-my-shell
        gnomeExtensions.auto-move-windows
        polkit_gnome
        gparted
    ]
}