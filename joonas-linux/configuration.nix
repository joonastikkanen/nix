{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Helsinki";
  time.hardwareClockInLocalTime = true;

  networking = {
    hostName = "joonas-linux";
    networkmanager.enable = true;
    firewall.enable = true;

    extraHosts = ''
      10.20.30.20 tikinas.localdomain
      10.20.30.40 tikiproxy.localdomain
    '';
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.joonas = {
     isNormalUser = true;
     extraGroups = [ "wheel" "kvm" "input" "disk" "libvirtd" ]; # Enable ‘sudo’ for the user.
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "steam" ]);
  nix.settings = {
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    layout = "fi";
    libinput = {
      enable = true;

      # disabling mouse acceleration
      mouse = {
        accelProfile = "flat";
      };
    };

    deviceSection = ''
        Identifier     "Device0"
        Driver         "nvidia"
        VendorName     "NVIDIA Corporation"
        BoardName      "NVIDIA GeForce GTX 1070"
      '';

    screenSection = ''
        Identifier     "Screen0"
        Device         "Device0"
        Monitor        "Monitor0"
        DefaultDepth    24
        Option         "Stereo" "0"
        Option         "nvidiaXineramaInfoOrder" "DFP-6"
        Option         "metamodes" "DP-4: 2560x1440_144 +2560+0, HDMI-0: 2560x1440_75 +0+0"
        Option         "SLI" "Off"
        Option         "MultiGPU" "Off"
        Option         "BaseMosaic" "off"
        SubSection     "Display"
            Depth       24
        EndSubSection
      '';
    excludePackages = with pkgs; [
        xterm
      ];
  };

  # NVIDIA
  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
    ];

  # Tell Xorg to use the nvidia driver
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is needed for most wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = true;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  ## Gaming
	programs.steam = {
	  enable = true;
	  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
	  dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
	};
	  

  # List services that you want to enable:
  virtualisation.libvirtd.enable = true; 
  # enable flatpak support
  services.flatpak.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
    ansible
    curl
    vim
    wget
    neofetch
    discord
    enpass
    flatpak
    freetype
    gcc
    gimp
    git
    google-chrome
    gparted
    hugo
    hunspellDicts.sv_FI
    nfs-utils
    libreoffice
    openssl
    pavucontrol
    polkit_gnome
    podman
    podman-desktop
    podman-compose
    qemu
    samba
    spotify
    steam
    steam-run
    teamspeak_client
    telegram-desktop
    unzip
    vagrant
    virt-manager
    vlc
    vscode
    vulkan-tools
    lutris
    (lutris.override {
          extraPkgs = pkgs: [
      # List package dependencies here
            wineWowPackages.stable
            winetricks
          ];
        })
  ];
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.user-themes
    gnomeExtensions.vitals
    gnomeExtensions.blur-my-shell
    gnomeExtensions.auto-move-windows
   ];
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
}