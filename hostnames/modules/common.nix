{ config, pkgs, ... }:

{
    services.fwupd.enable = true;
    environment.systemPackages = with pkgs; [
        curl
        git
        neofetch
        ncdu
        openssl
        tmux
        unzip
        unrar
        vim
        wget
        htop
        jq
        yq
    ];
}