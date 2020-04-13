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
    sha256 = "1342f84d4324987f63307eb6a5aac2dff6d27967860a129f5cd40f8f9b6fd7dd",
    strip_prefix = "bazel-toolchains-2.2.0",
    urls = [
        "https://github.com/bazelbuild/bazel-toolchains/releases/download/2.2.0/bazel-toolchains-2.2.0.tar.gz",
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/releases/download/2.2.0/bazel-toolchains-2.2.0.tar.gz",
    ],
)

load("//:setup.bzl", "kythe_rule_repositories", "maybe")

# NOTE(treetide): local modification, we hardwired the nix-based values here.
register_toolchains("//tools/build_rules/lexyacc:lexyacc_local_toolchain")

register_toolchains("//:py_pair_toolchain")

kythe_rule_repositories()

# NOTE(treetide): local modification, manage go toolchain from nix
#   (see external.bzl for commented out original bazel-y pull).
#   However, as the go toolchain is more pinned from bazel now, we could let
#   bazel manage it (?).
load(
    "@io_bazel_rules_go//go:deps.bzl",
    "go_wrap_sdk")
go_wrap_sdk(
    "go_sdk",
    root_file = "@wrapped_go_sdk//:share/go/iamhere",
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

# If the configuration here changes, run tools/platforms/configs/rebuild.sh
load("@bazel_toolchains//rules:environments.bzl", "clang_env")
load("@bazel_toolchains//rules:rbe_repo.bzl", "rbe_autoconfig")
load("//tools/platforms:toolchain_config_suite_spec.bzl", "DEFAULT_TOOLCHAIN_CONFIG_SUITE_SPEC")

rbe_autoconfig(
    name = "rbe_default",
    env = clang_env(),
    export_configs = True,
    toolchain_config_suite_spec = DEFAULT_TOOLCHAIN_CONFIG_SUITE_SPEC,
    use_legacy_platform_definition = False,
)

rbe_autoconfig(
    name = "rbe_bazel_minversion",
    bazel_version = MIN_VERSION,
    env = clang_env(),
    export_configs = True,
    toolchain_config_suite_spec = DEFAULT_TOOLCHAIN_CONFIG_SUITE_SPEC,
    use_legacy_platform_definition = False,
)

rbe_autoconfig(
    name = "rbe_bazel_maxversion",
    bazel_version = MAX_VERSION,
    env = clang_env(),
    export_configs = True,
    toolchain_config_suite_spec = DEFAULT_TOOLCHAIN_CONFIG_SUITE_SPEC,
    use_legacy_platform_definition = False,
)
