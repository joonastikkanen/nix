{lib, pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    shellAliases = {
      k = "kubectl";
      ll = "ls -lsa";
    };
    history = {
      size = 10000;
      save = 1000000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "argocd"
        "docker"
        "git"
        "helm"
        "kubectl"
        "sudo"
        "systemd"
      ];
      theme = "";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
      '')
      ''
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      ''
    ];
  };
}
