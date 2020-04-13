{ pkgs ? (import ./default.nix).nixpkgs {} }:

with pkgs;
{ kythe-compile = stdenv.mkDerivation {
    name = "kythe-compile";
    buildInputs = [
      bazel cmake zlib asciidoc sourceHighlight libuuid.dev ncurses.dev jdk
      # TODO(robinp): pull in with nixpkgs? now bazel-build works if triggered
      # from nix-shell, but a pure nix-build would fail?
      graphviz python go coreutils
      # for git lint hook
      arcanist
    ];
    shellHook = ''
      echo === Generating .bazelrc.nix fragment.
      sh gen-bazelrc-nix.sh
    '';
};
}
