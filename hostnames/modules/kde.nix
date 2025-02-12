{ config, pkgs, ... }:

{
    services.xserver = {
        enable = true;
        xkb.variant = "";
        xkb.layout = "fi";

        excludePackages = with pkgs; [
            xterm
        ];
    };
    services.displayManager = {
        sddm = {
            enable = true;
            wayland.enable = true;
        };
        defaultSession = "plasma";
    };
    services.desktopManager.plasma6.enable = true;

    services.libinput = {
        enable = true;
        # disabling mouse acceleration
        mouse = {
            accelProfile = "flat";
        };
    };

    qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
    };
}
