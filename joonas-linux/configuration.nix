{ 
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Helsinki";

  networking = {
    hostName = "joonas-linux";
    firewall.enable = true;

    extraHosts = ''
      10.20.30.20 tikinas.localdomain
      10.20.30.40 tikiproxy.localdomain
    '';
  };
}