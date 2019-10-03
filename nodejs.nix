# Silly trick to get rules_nodejs accept our vendored nodejs.
{ pkgs ? (import ./default.nix).nixpkgs {} }:
with pkgs;
let node_used = nodejs-10_x;
in {
  wrapped_node = stdenv.mkDerivation {
    name = "wrapped_node";
    buildInputs = [ node_used ];
    buildCommand = ''
      mkdir $out
      cp -r ${node_used} $out/top
    '';
  };
}
