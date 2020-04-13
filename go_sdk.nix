{ pkgs ? (import ./default.nix).nixpkgs {} }:
with pkgs;
{
  wrapped_go_sdk = stdenv.mkDerivation {
    name = "wrapped_go_sdk";
    buildInputs = [ go ];
    buildCommand = ''
      cp -r ${go} $out
      chmod +wx $out/share/go
      touch $out/share/go/iamhere  # Needs to be a regular file for bazel go_wrap_sdk rule.

      # Needs to be writeable, so nix sandbox doesn't complain. Don't ask.
      chmod +wx $out
    '';
  };
}
