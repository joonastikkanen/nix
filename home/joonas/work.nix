{...}: {
  imports = [
    ../modules/firefox.nix
    ../modules/tmux.nix
   ];

  # nixpkgs configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  programs.git.settings = {
    enable = true;
    user.name = "Joonas Tikkanen";
    user.email = "joonas.tikkanen@kinetive.fi";
    extraConfig = {
      pull.rebase = "true";
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      k = "kubectl";
    };
    historyFileSize = 1000000;
    historySize = 10000;
    initExtra = ''
        export PS1='\[\e[38;5;253m\]\t\[\e[0m\] [\u@\h:\[\e[1m\]\w\[\e[0m\]]\\$ '
        source <(kubectl completion bash)
        export PATH=$PATH:~/bin:~/.local/bin
        '';
  };

  home = {
    username = "joonas";
    homeDirectory = "/home/joonas";
  };

  programs.ssh = {
    matchBlocks."*" = { 
      forwardAgent = true; 
      addKeysToAgent = "yes"; 
      compression = false; 
      serverAliveInterval = 0; 
      serverAliveCountMax = 3; 
      hashKnownHosts = false; 
      userKnownHostsFile = "~/.ssh/known_hosts"; 
      controlMaster = "no"; 
      controlPath = "~/.ssh/master-%r@%n:%p"; 
      controlPersist = "no"; 
    };
    extraConfig = ''
    Host *
      ServerAliveInterval 300
      ServerAliveCountMax 5
      IPQoS=throughput
      ForwardAgent yes

    Host gitlab
      User tiki
      Hostname gitlab.kinetive.fi
      Port 2022
    '';
  };

  services.gnome-keyring.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.05";
}
