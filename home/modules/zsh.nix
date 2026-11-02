{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      k = "kubectl";
      ll = "ls -lsa";
    };
    history = {
      size = 10000;
      save = 1000000;
    };
    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
      theme = "";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    initContent = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };
}
