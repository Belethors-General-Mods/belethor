{ config, lib, pkgs, ... }:

{
  # Enable the Postgresql database
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    package = pkgs.postgresql_9_6;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host  all all localhost trust
      host  all all 127.0.0.1/32 trust
    '';

    initialScript = pkgs.writeText "backend-initScript" ''
      ALTER USER postgres WITH PASSWORD 'postgresql';
    '';
  };
}
