workspace(
    name = "io_kythe",
    managed_directories = {"@npm": ["node_modules"]},
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//:version.bzl", "MAX_VERSION", "MIN_VERSION", "check_version")

# Check that the user has a version between our minimum supported version of
# Bazel and our maximum supported version of Bazel.
check_version(MIN_VERSION, MAX_VERSION)

### nixpkgs setup
http_archive(
  name = "io_tweag_rules_nixpkgs",
  strip_prefix = "rules_nixpkgs-0.5.1",
  urls = ["https://github.com/tweag/rules_nixpkgs/archive/v0.5.1.tar.gz"],
)

load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package", "nixpkgs_git_repository")

nixpkgs_git_repository(
  name = "nixpkgs",
  revision = "e19054ab3cd5b7cc9a01d0efc71c8fe310541065",
)

nixpkgs_package(
  name = "coreutils",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

nixpkgs_package(
  name = "python",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

nixpkgs_package(
  name = "python3",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

nixpkgs_package(
  name = "flex",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

nixpkgs_package(
  name = "yacc",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

nixpkgs_package(
  name = "bison",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
)

#
# NOTE(treetide): local nix mod to vendor the GO sdk.
#
nixpkgs_package(
  name = "wrapped_go_sdk",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
  nix_file = "//:go_sdk.nix",
  attribute_path = "wrapped_go_sdk",
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
    sha256 = "56e75f7c9bb074f35b71a9950917fbd036bd1433f9f5be7c04bace0e68eb804a",
    strip_prefix = "bazel-toolchains-9bd2748ec99d72bec41c88eecc3b7bd19d91a0c7",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/9bd2748ec99d72bec41c88eecc3b7bd19d91a0c7.tar.gz",
        "https://github.com/bazelbuild/bazel-toolchains/archive/9bd2748ec99d72bec41c88eecc3b7bd19d91a0c7.tar.gz",
    ],
)

load("//:setup.bzl", "kythe_rule_repositories", "maybe")

# NOTE(treetide): local modification, we hardwired the nix-based values here.
register_toolchains("//tools/build_rules/lexyacc:lexyacc_local_toolchain")

register_toolchains("//:py_pair_toolchain")

kythe_rule_repositories()

# NOTE(treetide): local
load(
    "@io_bazel_rules_go//go:deps.bzl",
    "go_wrap_sdk")
go_wrap_sdk(
    "go_sdk",
    root_file = "@wrapped_go_sdk//:share/go/iamhere",
)

# TODO(schroederc): remove this.  This needs to be loaded before loading the
# go_* rules.  Normally, this is done by go_rules_dependencies in external.bzl,
# but because we want to overload some of those dependencies, we need the go_*
# rules before go_rules_dependencies.  Likewise, we can't precisely control
# when loads occur within a Starlark file so we now need to load this
# manually... https://github.com/bazelbuild/rules_go/issues/1966
load("@io_bazel_rules_go//go/private:compat/compat_repo.bzl", "go_rules_compat")

maybe(
    go_rules_compat,
    name = "io_bazel_rules_go_compat",
)

# gazelle:repository_macro external.bzl%_go_dependencies
load("//:external.bzl", "kythe_dependencies")

kythe_dependencies()

load("//tools/build_rules/external_tools:external_tools_configure.bzl", "external_tools_configure")

external_tools_configure()

load("@build_bazel_rules_nodejs//:index.bzl", "npm_install", "node_repositories")

#
# NOTE(treetide): local nix mod to vendor nodejs.
#
nixpkgs_package(
  name = "my_nodejs",
  repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
  nix_file = "//:nodejs.nix",
  attribute_path = "wrapped_node",
  build_file_content = """
package(default_visibility = ["//visibility:public"])

filegroup(
    name = "top",
    srcs = glob(["**/*"]),
)
  """,
)

node_repositories(
    package_json = ["//:package.json"],
    node_version = "10.16.0",  # check if you update pinning
    vendored_node = "@my_nodejs//:top",
)

npm_install(
    name = "npm",
    package_json = "//:package.json",
    package_lock_json = "//:package-lock.json",
)

load("@npm//:install_bazel_dependencies.bzl", "install_bazel_dependencies")

install_bazel_dependencies()

load("@npm_bazel_typescript//:index.bzl", "ts_setup_workspace")

ts_setup_workspace()

# This binding is needed for protobuf. See https://github.com/protocolbuffers/protobuf/pull/5811
bind(
    name = "error_prone_annotations",
    actual = "@maven//:com_google_errorprone_error_prone_annotations",
)

load("@maven//:compat.bzl", "compat_repositories")

compat_repositories()
