{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;
  environment.systemPackages = [
    # ... other packages
    pkgs.kitty # required for the default Hyprland config
    (pkgs.waybar.overrideAttrs (oldAttrs: {
    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
     })
    )
    pkgs.dunst
    pkgs.libnotify
    pkgs.hyprpaper
    pkgs.rofi-wayland
    ];

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Nordic";
        icon-theme = "Nordic-darker";
        font-name = "Noto Sans Medium 11";
        document-font-name = "Noto Sans Medium 11";
        monospace-font-name = "Monospace 11";
      };
    }
  ];

  environment.sessionVariables = {
    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}