{lib, pkgs, ...}: {
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        clock-format = "24h";
        clock-show-weekday = true;
        show-battery-percentage = true;
        monospace-font-name = "FiraCode Nerd Font 11";
      };
      "org/gnome/desktop/calendar".show-weekdate = true;
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
        resize-with-right-button = true;
      };
      "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
      "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
      "org/gnome/mutter" = {
        dynamic-workspaces = true;
        edge-tiling = true;
      };
      "org/gnome/nautilus/preferences".default-folder-viewer = "list-view";
      "org/gnome/Console" = {
        use-system-font = true;
        scrollback-lines = lib.gvariant.mkInt64 100000;
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          appindicator.extensionUuid
          dash-to-dock.extensionUuid
        ];
        favorite-apps = [
          "firefox.desktop"
          "org.gnome.Nautilus.desktop"
          "org.gnome.Console.desktop"
          "code.desktop"
        ];
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-position = "BOTTOM";
        dash-max-icon-size = 40;
        dock-fixed = false;
        intellihide = true;
        multi-monitor = true;
        click-action = "minimize-or-previews";
        scroll-action = "cycle-windows";
        show-trash = false;
        show-mounts = false;
      };
      "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
      ];
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
        name = "Terminal";
        command = "${pkgs.gnome-console}/bin/kgx";
        binding = "<Primary><Alt>t";
      };
    };
  };
}
