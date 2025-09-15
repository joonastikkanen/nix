# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../modules/common.nix
      #../modules/gnome.nix
      ../modules/kde.nix
      #../modules/hyprland.nix
      ../modules/locales.nix
      ../modules/sound.nix
      #../modules/nvidia.nix
      #../modules/amd-gpu.nix
      ../modules/networking.nix
      ../modules/tailscale.nix
      ../modules/gaming.nix
    ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader = {
      systemd-boot = {
        enable = true;
        edk2-uefi-shell.enable = true;
        memtest86.enable = true;
        configurationLimit = 5;
        windows.winkkari.title = "Windows 10";
        windows.winkkari.efiDeviceHandle = "HD1b";
      };
      efi.canTouchEfiVariables = true;
  };
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/DATA" =
    { device = "/dev/disk/by-label/DATA";
      fsType = "ntfs-3g"; 
      options = [ "rw" "uid=1000" "gid=1000" ];
    };

  #fileSystems."/mnt/TIKINAS" = {
  #  device = "10.20.30.20:/data";
  #  fsType = "nfs";
  #};

  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
  ];

  networking.hostName = "joonas-linux";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joonas = {
    isNormalUser = true;
    description = "Joonas Tikkanen";
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "disk" "libvirtd" "dialout" "docker" ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "joonas";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
    bitwarden
    discord
    distrobox
    flatpak
    fondo
    freetype
    freecad-wayland
    fluent-gtk-theme
    fluent-icon-theme
    graphite-cursors
    graphite-gtk-theme
    gcc
    gimp
    go
    google-chrome
    gparted
    hugo
    hunspellDicts.sv_FI
    kid3
    keepassxc
    ledfx
    libreoffice
    nordic
    pavucontrol
    python311
    python311Packages.pip
    openrgb
    signal-desktop
    spotify
    sweet
    sweethome3d.application
    telegram-desktop
    terminator
    whatsapp-for-linux
    virt-manager
    vlc
    vscode
  ];

  system = {
    stateVersion = "24.11";
  };

}

