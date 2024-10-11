{ config, pkgs, lib, ... }:
{
  # NVIDIA
  # Make sure opengl is enabled
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [ pkgs.mesa.drivers ];
  };

  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
    ];

  # Tell Xorg to use the nvidia driver
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is needed for most wayland compositors
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = false;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    forceFullCompositionPipeline = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}