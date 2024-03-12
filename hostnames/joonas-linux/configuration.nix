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
      ../../modules/gnome.nix
      ../../modules/locales.nix
      ../../modules/sound.nix
      ../../modules/nvidia.nix
      ../../modules/networking.nix
      ../../modules/tailscale.nix
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

  networking.hostName = "joonas-linux";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joonas = {
    isNormalUser = true;
    description = "Joonas Tikkanen";
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "disk" "libvirtd" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
  	"electron-24.8.6"
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
    bitwarden
    discord
    unstable.enpass
    flatpak
    freetype
    gcc
    gimp
    go
    google-chrome
    gparted
    hugo
    hunspellDicts.sv_FI
    kid3
    libreoffice
    pavucontrol
    spotify
    sweethome3d.application
    teamspeak_client
    telegram-desktop
    vlc
    unstable.whatsapp-for-linux
  ];

  system = {
    stateVersion = "23.05";
    autoUpgrade = {
      enable = true;
      allowReboot = false;
    };
  };

}

