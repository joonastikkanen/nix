{ config, pkgs, ... }:

{
    services = {
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
    };
    services.xserver = {
        enable = true;
        xkb.variant = "";
        xkb.layout = "fi";

        excludePackages = with pkgs; [
            xterm
        ];
    };

    services.libinput = {
        enable = true;
        # disabling mouse acceleration
        mouse = {
            accelProfile = "flat";
        };
    };

    environment.systemPackages = with pkgs; [
        gnomeExtensions.appindicator
        gnomeExtensions.sound-output-device-chooser
        gnomeExtensions.user-themes
        gnomeExtensions.vitals
        gnomeExtensions.blur-my-shell
        gnomeExtensions.auto-move-windows
        gnomeExtensions.dash-to-dock
        gnome-tweaks
        polkit_gnome
        gparted
    ];
}
