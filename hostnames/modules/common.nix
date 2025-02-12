{ config, pkgs, ... }:

{
    programs.ssh.startAgent = true;
    security.sudo.wheelNeedsPassword = false;
    services.fwupd.enable = true;
    environment.systemPackages = with pkgs; [
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
        trusted-users = ["root joonas" "@wheel"];
        extra-substituters = https://devenv.cachix.org;
        extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=;
    };
}