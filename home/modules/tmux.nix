{ pkgs, ... }: {
    programs.tmux = {
        clock24 = true;
        mouse = true;
        plugins = with pkgs; [
            tmuxPlugins.yank
            tmuxPlugins.cpu
        ];
    };
}