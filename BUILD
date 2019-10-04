package(default_visibility = ["//visibility:private"])

load("//:version.bzl", "MAX_VERSION", "MIN_VERSION")

exports_files(glob(["*"]))

filegroup(
    name = "nothing",
    visibility = ["//visibility:public"],
)

config_setting(
    name = "darwin",
    values = {"cpu": "darwin"},
    visibility = ["//visibility:public"],
)

sh_test(
    name = "check_bazel_versions",
    srcs = ["//tools:check_bazel_versions.sh"],
    args = [
        MIN_VERSION,
        MAX_VERSION,
    ],
    data = [
        ".bazelminversion",
        ".bazelversion",
    ],
)

load("@rules_python//python:defs.bzl", "py_runtime_pair")

py_runtime(
  name = "python2_runtime",
  python_version = "PY2",
  files = [],
  interpreter = "@python//:bin/python",
)

py_runtime(
  name = "python3_runtime",
  python_version = "PY3",
  files = [],
  interpreter = "@python3//:bin/python",
)

py_runtime_pair(
  name = "my_python_pairs",
  py2_runtime = ":python2_runtime",
  py3_runtime = ":python3_runtime",
)

toolchain(
  name = "py_pair_toolchain",
  #target_compatible_with = <...>,
  toolchain = ":my_python_pairs",
  toolchain_type = "@rules_python//python:toolchain_type",
)
