{...}: {
    programs.ssh = {
        serverAliveCountMax = 5;
        serverAliveInterval = 300;
        forwardAgent = true;
    };
}