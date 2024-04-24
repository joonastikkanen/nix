{...}: {
    programs.ssh = {
        startAgent = true;
        serverAliveCountMax = 5;
        serverAliveInterval = 300;
        forwardAgent = true;
    };
}