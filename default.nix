{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;

  elixir = beam.packages.erlangR21.elixir_1_8;
  nodejs = nodejs-11_x;
  postgresql = postgresql_11;
in

mkShell {
  buildInputs = [
      elixir
      nodejs
      postgresql
      git
    ]
    ++ optional stdenv.isLinux glibcLocales # To allow setting consistent locale on linux
    ++ optional stdenv.isLinux inotify-tools # For file_system
    ++ optional stdenv.isLinux libnotify # For ExUnit
    ;

    # Set up environment vars
    shellHook = ''
      export LANG="en_US.UTF-8"
      export LC_ALL="en_US.UTF-8"
      export PGDATA="$PWD/db"
    '';
}
