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
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/xxx";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/xxx";
      fsType = "vfat";
    };


  networking = {
    hostName = "kinetive";
    networkmanager.enable = true;
    firewall.enable = true;

    extraHosts = ''
      10.20.30.20 tikinas
      10.20.30.40 tikiproxy
      10.20.30.50 homeassistant
      10.20.30.60 watermeter
    '';
  };

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

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services.fprintd.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joonas = {
    isNormalUser = true;
    description = "Joonas Tikkanen";
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "disk" "libvirtd" ];
  };
  
  virtualisation.libvirtd.enable = true; 

  services.tailscale.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
    android-tools
    ansible
    awscli2
    azure-cli
    curl
    vim
    wget
    neofetch
    dbeaver
    enpass
    flatpak
    freetype
    firefox
    gcc
    gimp
    git
    google-chrome
    google-cloud-sdk
    gnomeExtensions.appindicator
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.user-themes
    gnomeExtensions.vitals
    gnomeExtensions.blur-my-shell
    gnomeExtensions.auto-move-windows
    gparted
    hugo
    hunspellDicts.sv_FI
    helm
    marktext
    nfs-utils
    nodenv
    nodejs_18
    keepassxc
    kubectl
    libreoffice
    openssl
    pavucontrol
    polkit_gnome
    podman
    podman-desktop
    podman-compose
    postman
    remmina
    qemu
    samba
    spotify
    teams
    telegram-desktop
    terraform
    tfswitch
    tmux
    unrar
    unzip
    vagrant
    virt-manager
    vlc
    unstable.vscode
    vulkan-tools
    whatsapp-for-linux
   ]
  system.stateVersion = "23.11"; 

}
