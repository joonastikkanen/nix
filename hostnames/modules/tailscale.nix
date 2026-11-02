{ config, pkgs, ... }:

{
  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = [
    "--login-server=https://headscale.joonastikkanen.fi"
  ];
}
