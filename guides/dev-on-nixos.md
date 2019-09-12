# This is a short guide on how to setup a development environment in NixOS


## install postgresql
This snippet needs to go into your `/etc/nixos/configuration.nix`.
It will install a postgresql database with a default password (!).
Don't use this in production.
```nix
{ config, pkgs, ... }:

{
  # Enable the Postgresql database
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all localhost trust
    '';

    initialScript = pkgs.writeText "backend-initScript" ''
      ALTER USER postgres WITH PASSWORD 'postgresql';
    '';
  };
}
```

## Elixir, Nodejs, etc
`cd` into the project root directory, then run `nix-shell --pure`.
You should enter a shell with elixir, erlang and nodejs installed.
The responsible configuration is in `default.nix`.
