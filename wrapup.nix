# Wraps up bazel compilation outputs in a standalone derivation, correctly
# capturing the dependent derivations.
#
# When you build some targets with nix-bazel, the built binaries will link
# against libraries in the nix store. If the binaries are copied somewhere and
# outlive the scope of the nix-bazel, those dependent libs might be GC'd away.
# Or they might simply not be present on remote systems.
#
# So the binaries are bundled into a nix derivation that records the
# dependencies, then standard nix tools like nix-copy-closure can be used to
# transfer the binaries with all their requisites to remote systems.
#
# Note: nix determines the dependent libs by scanning the content of the
# outputs for nix store hashes. Two caveats here:
#
#  - If you "hide" the hashes by say zipping the outputs, the deps won't be
#    picked up. (Maybe there's some nix magic wrapper around tar?)
#
#  - The hashes scanned are not from the whole nix store, just those of the
#    buildInputs of this derivation. So you have to duplicate any runtime
#    deps into the buildInputs below.
#
# Note:
#
# This derivation is not self-contained, since the binaries already need  to be
# built.
#
# Why would you use this instead a derivation that properly invokes
# bazel? That would run bazel in a clean environment, discarding caches. That's
# fine for a periodic release, but for continuous development this wrapper is
# more convenient.
#
# Usage:
#
#    nix-build wrapup.nix
#
#    # Check the deps needed.
#    nix-store --query --requisites result
#
{ pkgs ? (import ./default.nix).nixpkgs {} }:

with pkgs;
stdenv.mkDerivation {
  name = "wrapped";
  src = ./bazel-bin;
  buildInputs = [
    libuuid
    ncurses
  ];
  installPhase = ''
    OUT=$out/bin
    mkdir -p $OUT
    for tool in kythe/go/serving/tools/write_tables/write_tables \
      kythe/go/serving/tools/http_server/http_server \
      kythe/go/storage/tools/write_entries/write_entries \
      kythe/go/platform/tools/entrystream/entrystream \
      kythe/cxx/extractor/cxx_extractor \
      kythe/cxx/indexer/cxx/indexer
    do
      TARGET_DIR=$OUT/$(dirname $tool)
      mkdir -p $TARGET_DIR
      cp $src/$tool $TARGET_DIR/
    done
  '';
}
