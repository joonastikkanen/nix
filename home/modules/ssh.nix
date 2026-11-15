{...}: {
    programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings."*" = {
            AddKeysToAgent = "yes";
            ServerAliveCountMax = 5;
            ServerAliveInterval = 300;
            ForwardAgent = true;
        };
    };
}
