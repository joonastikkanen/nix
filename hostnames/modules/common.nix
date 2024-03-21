{ config, pkgs, ... }:

{
    security.sudo.wheelNeedsPassword = false;
    services.fwupd.enable = true;
    environment.systemPackages = with pkgs; [
        curl
        git
        neofetch
        ncdu
        nnn
        openssl
        tmux
        unzip
        unrar
        vim
        wget
        htop
        jq
        yq
        git
        tree
        pciutils
        dnsutils
        inetutils
        file
        nmap
        usbutils
    ];
    nix.settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
    };
}