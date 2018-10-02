{ pkgs ? import <nixpkgs> {} }:

with pkgs;
{ kythe-compile = stdenv.mkDerivation {
    name = "kythe-compile";
    buildInputs = [ zlib asciidoc sourceHighlight libuuid ncurses.dev ];
};
}
