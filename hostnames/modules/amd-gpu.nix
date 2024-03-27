{ config, pkgs, lib, ... }:
{
    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.opengl.driSupport = true; # This is already enabled by default
    hardware.opengl.driSupport32Bit = true; # For 32 bit applications

    hardware.opengl.extraPackages = with pkgs; [
        amdvlk
    ];
    # For 32 bit applications 
    hardware.opengl.extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
    ];
}
