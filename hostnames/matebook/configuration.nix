# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, ... }:

{
  nix.nixPath = [ "nixos-config=$PWD/configuration.nix" ];
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../modules/gnome.nix
      ../modules/locales.nix
      ../modules/sound.nix
      ../modules/nvidia.nix
      ../modules/networking.nix
      ../modules/laptop.nix
      ../modules/tailscale.nix
      ../modules/common.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/538eba3e-06ca-4929-97ab-29b158bf615e";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/AB37-12BC";
      fsType = "vfat";
    };

  swapDevices = [ ];

  networking.hostName = "matebook";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joonas = {
    isNormalUser = true;
    description = "Joonas Tikkanen";
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "disk" "libvirtd" ];
  };
  
  users.users.miia = {
    isNormalUser = true;
    description = "Miia Tikkanen";
    extraGroups = [];
  };
  # NVIDIA PRIME
  hardware.nvidia = {
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
    ansible
    awscli2
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

    samba
    spotify
    steam
    steam-run
    teamspeak_client
    telegram-desktop
    unzip
    vagrant
    vlc
    vscode
    vulkan-tools
    whatsapp-for-linux
    lutris
    (lutris.override {
          extraPkgs = pkgs: [
      # List package dependencies here
            wineWowPackages.stable
            winetricks
          ];
        })
  ];

  system.stateVersion = "23.05"; # Did you read the comment?

}

