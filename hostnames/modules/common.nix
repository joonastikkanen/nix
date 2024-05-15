{ config, pkgs, ... }:

{
    programs.ssh.startAgent = true;
    security.sudo.wheelNeedsPassword = false;
    services.fwupd.enable = true;
    environment.systemPackages = with pkgs; [
        async
        curl
        dnsutils
        file
        git
        htop
        inetutils
        jq
        localsend
        ncdu
        neofetch
        nmap
        nnn
        openssl
        pciutils
        tmux
        tree
        uncgi
        unrar
        unzip
        usbutils
        vim
        wget
        yq
    ];
    nix.settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
    };
}