{config, lib, pkgs, ...}: {
  home.packages = with pkgs; [
    ubuntu-classic
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
  ];
  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    enable = true;
    package = pkgs.yaru-theme;
    name = "Yaru";
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.yaru-theme;
      name = "Yaru-dark";
    };
    iconTheme = {
      package = pkgs.yaru-theme;
      name = "Yaru";
    };
    font = {
      name = "Ubuntu";
      size = 11;
    };
    # Modern libadwaita apps use GNOME's dark mode and orange accent.
    gtk4.theme = null;
    gtk3.extraCss = "/* Use the selected theme without legacy Plasma color overrides. */";
    gtk4.extraCss = "/* Use GNOME colors without legacy Plasma color overrides. */";
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        cursor-theme = config.home.pointerCursor.name;
        cursor-size = config.home.pointerCursor.size;
        color-scheme = "prefer-dark";
        accent-color = "orange";
        document-font-name = "Ubuntu 11";
        clock-format = "24h";
        clock-show-weekday = true;
        show-battery-percentage = true;
        monospace-font-name = "FiraCode Nerd Font 11";
      };
      "org/gnome/desktop/calendar".show-weekdate = true;
      "org/gnome/desktop/background" = {
        picture-uri = "file://${./wallpapers/ubuntu-inspired.svg}";
        picture-uri-dark = "file://${./wallpapers/ubuntu-inspired.svg}";
        picture-options = "zoom";
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ":minimize,maximize,close";
        titlebar-font = "Ubuntu Bold 11";
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
          user-themes.extensionUuid
        ];
        favorite-apps = [
          "firefox.desktop"
          "org.gnome.Nautilus.desktop"
          "org.gnome.Console.desktop"
          "code.desktop"
        ];
      };
      "org/gnome/shell/extensions/user-theme".name = "Yaru-dark";
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-position = "LEFT";
        dock-fixed = true;
        intellihide = false;
        autohide = false;
        extend-height = true;
        dash-max-icon-size = 48;
        custom-theme-shrink = true;
        multi-monitor = true;
        show-apps-at-top = false;
        show-trash = true;
        show-mounts = true;
        click-action = "minimize-or-previews";
        scroll-action = "cycle-windows";
        transparency-mode = "FIXED";
        background-opacity = 0.9;
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
