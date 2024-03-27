# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../modules/common.nix
      ../modules/locales.nix
      ../modules/laptop.nix
      ../modules/tailscale.nix
      ../modules/gnome.nix
      ../modules/devops.nix
      ../modules/networking.nix
    ];

  # Bootloader.
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/8aac8772-7655-4944-8c5f-ba24eed971c2";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3026-D1E9";
      fsType = "vfat";
  };

  networking.hostName = "work";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joonas = {
    isNormalUser = true;
    description = "Joonas Tikkanen";
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "disk" "libvirtd" ];
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
    enpass
    evince
    flatpak
    fondo
    freetype
    firefox
    gimp
    google-chrome
    hunspellDicts.sv_FI
    marktext
    keepassxc
    libreoffice
    pavucontrol
    spotify
    slack
    signal-desktop
    telegram-desktop
    vlc
    whatsapp-for-linux
   ];
  system.stateVersion = "nixos-unstable"; 

}
