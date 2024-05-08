{ config, pkgs, ... }:

{
    services.xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
        xkb.variant = "";
        xkb.layout = "fi";
        libinput = {
        enable = true;
        };

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
        gnome.gnome-tweaks
        polkit_gnome
        gparted
    ];
}
