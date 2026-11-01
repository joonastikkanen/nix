{...}: {
    programs.ssh = {
        settings."*" = {
            ServerAliveCountMax = 5;
            ServerAliveInterval = 300;
            ForwardAgent = true;
        };
    };
}
