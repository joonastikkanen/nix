# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  publicDnsServer = "8.8.8.8";
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../modules/common.nix
      ../modules/locales.nix
      ../modules/ssh.nix
      ../modules/tailscale.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
  };

   networking = {

    hostName = "nix-router";
    nameservers = [ "${publicDnsServer}" ];
    firewall.enable = false;

    interfaces = {
      enp1s0 = {
        useDHCP = true;
      };
      enp2s0 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "10.20.30.1";
          prefixLength = 24;
        }]
      };
      enp3s0 = {
        useDHCP = false;
      };
      enp4s0 = {
        useDHCP = false;
      };
      enp5s0 = {
        useDHCP = false;
      };
      enp6s0 = {
        useDHCP = false;
      };
      enp7s0 = {
        useDHCP = false;
      };
      enp7s0 = {
        useDHCP = false;
      };
      wlp9s0 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "10.20.40.1";
          prefixLength = 24;
        }]
      }
    };

    nftables = {
      enable = true;
      ruleset = ''
        table ip filter {
          chain input {
            type filter hook input priority 0; policy drop;

            iifname { "enp2s0", "wlp9s0" } accept comment "Allow local network to access the router"
            iifname "enp1s0" ct state { established, related } accept comment "Allow established traffic"
            iifname "enp1s0" icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow select ICMP"
            iifname "enp1s0" counter drop comment "Drop all other unsolicited traffic from wan"
          }
          chain forward {
            type filter hook forward priority 0; policy drop;
            iifname { "enp2s0", "wlp9s0" } oifname { "enp1s0" } accept comment "Allow trusted LAN to WAN"
            iifname { "enp1s0" } oifname { "enp2s0", "wlp9s0" } ct state established, related accept comment "Allow established back to LANs"
            iifname { "enp2s0" } oifname { "wlp9s0" } counter accept comment "Allow trusted LAN to IoT"
            iifname { "wlp9s0" } oifname { "enp2s0" } ct state { established, related } counter accept comment "Allow established back to LANs"
          }
        }

        table ip nat {
          chain postrouting {
            type nat hook postrouting priority 100; policy accept;
            oifname "enp1s0" masquerade
            oifname "wlp9s0" masquerade
          } 
        }

        table ip6 filter {
	        chain input {
            type filter hook input priority 0; policy drop;
          }
          chain forward {
            type filter hook forward priority 0; policy drop;
          }
        }
      '';
    };
  };

  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "enp1s0";
      WIFI_IFACE = "wlp9s0";
      SSID = "SipsikulhoIoT";
      PASSPHRASE = "bileet72h";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joonas = {
    isNormalUser = true;
    description = "Joonas Tikkanen";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAklY2OI4S534W3JzBM0oUhTIGTNnVIFrcypkgN4THczMm/6tnPgw9tkEPJqPrWGto2mgUhrYx18cXe+hTZLCCK+TIlXok60PosunQtZ1CIcUe30IhE927nFAUz+otN9KolyeuMKhsPK9Ei/0ZSvh4K79JwPUTi5KnZqwOnjnxlkMz/pz8pYQSGahi4H4QnRxutdchb4T8ycXrZvk1tlYVef1RnKebfvbfNb9aFx644N5+GaHGr/HwEaWLdurQMEb/h8zh1kNc7Dzfk3iGSnJvHri0AEtbr0GmI3r4Iofzgw5Ix+5hbU2+AZtNistA6+IeBG5fJgpn6On1qS7sAVgsWw== joonas.tikkanen91@gmail.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA5VgOodGHpCrSSAPik03K3XRCGzEoDR3383h6UPsgjWQNALPGfqpJIF48Qv9SPZDIYqoBAE/kYd5v2wcMjpKVpNUnHmx8gc7fA3mvs2uSV8azrxwk5LI7vRdcKzoyg3tiy6VwJR2UMcfTMwiZD168DYJvlsPl1+Q7PUfWNfisMBpJMzY76jrB/GUn9wvGL1Ywh6Gj2Psz1hm4/gKGkthvAYnMZnBp5BYGnLjhxjWxaxQK7gBqAb3xyRWIgQJVnSJnBnbNrkOS9lzgEnhR9/jy8iBPH8ilcWuLq/cYA1aGVkHWT1tmXtMEz4+BWrUdpS5pHEOk5m9WkcE3stb6ofqADQ== joonas.tikkanen@ambientia.fi"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDB/iCK0H72AADyoPibhv9VlV4FUojUX4+JrbL4dhmIu+q7khEbTrsLQd2Y66i1Wuefvc9+Xu7IyZf4ItnauowNCBvgdo8jo4D2JcaUnc8W9WpGW5XxKSQkIYr7IbAYHr/iSMgTX9d8Sl/UpDtcafrZb8NMVsgP99V84MjE9X844AAcw4Pd7ZArOCPjxnwgDLlDjEoauKiecQyx++OJNZY3/Ff8cYeQ5+cOQ+EdYBzNmLMOVIlh+1J/Zuv3R/5A3H7JO7zJaj0eYL+18HzVS8apw3lIUe+dRj7V9vrb74XkKKazuUEGlXsa2tsYNlv2ia2sPE0Xsuy1sQPM/g9OgSVU6K0EhIJIiqddUbe1tWgu2bieym82VVWq7u1rLuWh3PI5C9c3y+wCzyTkAEc8GhaV25+TotTlcp3O4htk3WiZOVz77NC6XRkd77laAGbn50weLiks1q3RT4eQRso3RuFFgF8bpcI8Kn9Ya5nkibyd88Vrca3Jp2vawC5zrWAKA19J/Zsaf6FI7fiqcyslifTVfzh26sbFKYR64XG9CvosQrstQxrt0XPuxZD/SwwnDNHo5p4uIbekWHvdxpAn3U1dNu2FmI/fn1AsI2/XnseOI/Si6f9u+gDkx89dOQ2Ll9rsAaN3O8m5nRca+RrhiAALX0j5wo44R3KSJrZeZnOBw== joonas.tikkanen91@gmail.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqHs+juS5reVO9nN3LtjbGpvLbYMowkiadHFLb3eEMvRCHulFrKcryeZZbsfJZ6Dmi26ptuUCLFTqhaI9B4AefPcdmNH9qjuYnkafXp2X+/8tvFrxp8iys7MnOv0oG/a5UtAJ5KBMBsQhXcqmvez2MZnaasAzy9R+w8BTXy0MExoylb7W/m0BY4ek1KrPdvcdnmr7spcDM/cbF+EtUTNE4qnMk6y2Ag2UWYiwsP9Wt6GISucKX/UvmTcVV8mpt9gHDtLHeohGUW/A9EqWTDYnvtz1uJ3Sl679AM5vSG7kVhp8FxEkoV6OiK0/TsOOzWpM0oMlLs+S9aD6VF70bYuqvKTOuvSFEbG1uijGA7FAeOcE8AX6Lo4N72BF6Tkl90sqWPYx5061i2R3Hhtghf0r71UVoAVgna6J5+FxEUKAd4s7k+PRGHWHWQeHJG8GURea0VoTzsz+DnU26Qf0EFhPGoM2C0OfyRisVYWP4CL37BkIh9nkSjUbgkZ2OcAdp9e8= matebook"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA9lCCDggJV1Xe8j/LfL80asF90L4NvnjwGwP0TrrMS3 joonas.tikkanen@kinetive.fi"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    tcpdump
    iperf
  ];

    dhcpd4 = {
      enable = true;
      interfaces = [ "enp2s0" ];
      machines = [
        { 
          hostName = "tikinas"; ethernetAddress = "4c:cc:6a:bb:7a:d9"; ipAddress = "10.20.30.20";
          hostName = "homeassistant"; ethernetAddress = "6c:4b:90:79:3e:f6"; ipAddress = "10.20.30.30";
        } 
      ];
      extraConfig = ''
        subnet 10.20.30.0 netmask 255.255.255.0 {
          option routers 10.20.30.1;
          option domain-name-servers ${publicDnsServer};
          option subnet-mask 255.255.255.0;
          interface enp2s0;
          range 10.20.30.2 10.20.30.254;
        
        subnet 10.20.40.0 netmask 255.255.255.0 {
          option routers 10.20.40.1;
          option domain-name-servers ${publicDnsServer};
          option subnet-mask 255.255.255.0;
          interface wlp9s0;
          range 10.20.40.2 10.20.30.254;
        }
      '';
    };

  system.stateVersion = "24.05"; # Did you read the comment?

}
