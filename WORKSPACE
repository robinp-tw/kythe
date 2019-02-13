workspace(name = "io_kythe")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")
load("//:version.bzl", "check_version")

# Check that the user has a version between our minimum supported version of
# Bazel and our maximum supported version of Bazel.
check_version("0.20", "0.22")

### nixpkgs setup
http_archive(
  name = "io_tweag_rules_nixpkgs",
  strip_prefix = "rules_nixpkgs-0.5.1",
  urls = ["https://github.com/tweag/rules_nixpkgs/archive/v0.5.1.tar.gz"],
)

load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package", "nixpkgs_git_repository")

nixpkgs_git_repository(
  name = "nixpkgs",
  revision = "def5124ec8367efdba95a99523dd06d918cb0ae8",
)

nixpkgs_package(
  name = "bison",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

nixpkgs_package(
  name = "flex",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

nixpkgs_package(
  name = "gzip",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

nixpkgs_package(
  name = "wget",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

nixpkgs_package(
  name = "curl",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

nixpkgs_package(
  name = "jre",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

nixpkgs_package(
  name = "gnutar",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

nixpkgs_package(
  name = "diffutils",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

nixpkgs_package(
  name = "diffstat",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

### end of nixpkgs setup

http_archive(
    name = "bazel_toolchains",
    sha256 = "0ffaab86bed3a0c8463dd63b1fe2218d8cad09e7f877075bf028f202f8df1ddc",
    strip_prefix = "bazel-toolchains-5ce127aee3b4c22ab76071de972b71190f29be6e",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/5ce127aee3b4c22ab76071de972b71190f29be6e.tar.gz",
        "https://github.com/bazelbuild/bazel-toolchains/archive/5ce127aee3b4c22ab76071de972b71190f29be6e.tar.gz",
    ],
)

load("//:setup.bzl", "kythe_rule_repositories")

kythe_rule_repositories()

load("//:external.bzl", "kythe_dependencies")

kythe_dependencies()

load("//tools/build_rules/external_tools:external_tools_configure.bzl", "external_tools_configure")

external_tools_configure()

load("@build_bazel_rules_nodejs//:defs.bzl", "npm_install")
load("@build_bazel_rules_nodejs//:defs.bzl", "node_repositories")

node_repositories(package_json = ["//:package.json"])

npm_install(
    name = "npm",
    package_json = "//:package.json",
    package_lock_json = "//:package-lock.json",
)
