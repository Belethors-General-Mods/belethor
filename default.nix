{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;

  elixir = beam.packages.erlangR21.elixir_1_8;
  nodejs = nodejs-11_x;
in

mkShell {
  buildInputs = [
      elixir
      nodejs
      git
    ]
    ++ optional stdenv.isLinux glibcLocales # To allow setting consistent locale on linux
    ++ optional stdenv.isLinux inotify-tools # For file_system
    ++ optional stdenv.isLinux libnotify # For ExUnit
    ;

  # Set up environment vars
  # We unset TERM b/c of https://github.com/NixOS/nix/issues/1056
  shellHook = ''
    unset TERM
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
  '';
}
