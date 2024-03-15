{...}: {
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
        '';
  };
}