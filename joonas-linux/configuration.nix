# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/DATA" =
    { device = "/dev/disk/by-label/DATA";
      fsType = "ntfs-3g"; 
      options = [ "rw" "uid=1000" "gid=1000" ];
    };

  fileSystems."/mnt/TIKINAS" = {
    device = "10.20.30.20:/data";
    fsType = "nfs";
  };

  networking = {
    hostName = "joonas-linux";
    networkmanager.enable = true;
    firewall.enable = true;

    extraHosts = ''
      10.20.30.20 tikinas
      10.20.30.30 homeassistant
      10.20.30.40 tikiproxy
    '';
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  # Enable the X11 windowing system.
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

  # Configure console keymap
  console.keyMap = "fi";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # NVIDIA
  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [ pkgs.mesa.drivers ];
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
    open = false;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joonas = {
    isNormalUser = true;
    description = "Joonas Tikkanen";
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "disk" "libvirtd" ];
  };
  
  virtualisation.libvirtd.enable = true; 
   
  services.tailscale.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
  	"electron-24.8.6"
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
    ansible
    bitwarden
    curl
    vim
    wget
    neofetch
    discord
    unstable.enpass
    flatpak
    freetype
    gcc
    gimp
    git
    go
    google-chrome
    gnomeExtensions.appindicator
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.user-themes
    gnomeExtensions.vitals
    gnomeExtensions.blur-my-shell
    gnomeExtensions.auto-move-windows
    gparted
    hugo
    hunspellDicts.sv_FI
    nfs-utils
    ncdu
    kid3
    libreoffice
    openssl
    pavucontrol
    polkit_gnome
    podman
    podman-desktop
    podman-compose
    qemu
    samba
    unstable.slack
    spotify
    unstable.steam
    steam-run
    sweethome3d.application
    teamspeak_client
    telegram-desktop
    unzip
    unrar
    vagrant
    virt-manager
    vlc
    unstable.vscode
    vulkan-tools
    unstable.whatsapp-for-linux
    lutris
    (lutris.override {
          extraPkgs = pkgs: [
      # List package dependencies here
            wineWowPackages.stable
            winetricks
          ];
        })
  ];

  system = {
    stateVersion = "23.05";
    autoUpgrade = {
      enable = true;
      allowReboot = false;
    };
  };

}

