{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;

  environment.systemPackages = [
    # ... other packages
    pkgs.kitty # required for the default Hyprland config
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
}