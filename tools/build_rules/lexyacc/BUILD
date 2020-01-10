package(default_visibility = ["//visibility:public"])

load("//tools/build_rules/lexyacc:lexyacc.bzl", "lexyacc_toolchain", "lexyacc_variables")

exports_files(["lexyacc.bzl"])

toolchain_type(name = "toolchain_type")

lexyacc_variables(name = "current_lexyacc_toolchain")

lexyacc_toolchain(
    name = "lexyacc_remote",
    # NOTE(treetide): local change, maybe not needed
    lex = "@flex//:bin/flex-remote",
    yacc = "@yacc//:bin/yacc-remote",
)

# Note: this is a hack now. Not used, since we manually override the tool
# at the rule use-site.
lexyacc_toolchain(
    name = "lexyacc_local",
    lex = "@flex//:bin/flex",
    yacc = "@yacc//:bin/yacc",
)

# NOTE(treetide): local addition. See register_toolchains in the WORKSPACE file
# as well.
#lexyacc_wrap_toolchain(
#    name = "lexyacc_local",
#    lex = "@flex//:bin/flex",
#    yacc = "@yacc//:bin/yacc",
#)

