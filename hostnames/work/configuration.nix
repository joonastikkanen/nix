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
  networking = {
    extraHosts = ''
      10.20.30.20 tikinas
      10.20.30.30 homeassistant
      10.20.30.40 tikiproxy
      10.20.30.60 watermeter
      #192.168.121.146 gitlab.kinetive.local registry.gitlab.kinetive.local storage.gitlab.kinetive.local 
      10.10.10.10 rancher.kinetive.local
      192.168.200.190 kinetivepi
    '';
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joonas = {
    isNormalUser = true;
    description = "Joonas Tikkanen";
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "disk" "libvirtd" "docker" "dialout"];
  };

  services.flatpak.enable = true;

 services.netbird = {
    enable = true;
    tunnels = {
      kalmar = {
        port = 51820;
        environment = {
          NB_MANAGEMENT_URL = "https://netbird.kalmar-one.com";
          NB_ADMIN_URL = "https://netbird.kalmar-one.com";
        };
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
    bitwarden
    enpass
    evince
    fondo
    freetype
    firefox
    gimp
    google-chrome
    gnome-firmware
    hunspellDicts.sv_FI
    keepassxc
    libreoffice
    marktext
    netbird
    netbird-ui
    netbird-dashboard
    pavucontrol
    signal-desktop
    slack
    spotify
    telegram-desktop
    vlc
    whatsapp-for-linux
    x2goclient
   ];
  system.stateVersion = "25.11"; 

}
