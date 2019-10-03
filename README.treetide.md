# Locally added files

shell.nix:
    Nix env needed to build kythe with Bazel.
    By default pinned to a version which was tested.

wrapup.nix:
    Wrap Kythe binaries (once built with Bazel) into a derivation that can
    be nix-copy-closure'd to remote machines.

cp-bin.sh:
    Puts build artifacts to a local dir. See warts described at the top of
    wrapup.nix.

# Notes

To compile Kythe:
  - in 'nix-shell' (uses shell.nix)
      - bazel build kythe/release
        - use 'bazel build -s' if anything goes wrong to see invocation details

      - if bazel complains about missing headers, then
        - 'bazel clean' and retry
        - if still, then wipe ~/.cache/bazel and retry.
        - note: this often happens when entering the nix-shell again, with old
          cached nix artifacts getting stale.
        - could as well just rebuild the toolchain.

      - bazel build kythe/cxx/extractor/...
        - BUG? why isn't libncursesw.so.6 picked up? even added ncurses.dev to nix-shell packages. It seems to be in NIX_LDPATH.
          - See https://github.com/NixOS/nixpkgs/issues/54112.
          - Changed to link against -lncurses for now.

