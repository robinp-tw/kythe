load("@bazel_skylib//lib:versions.bzl", "versions")

def genlex(name, src, out, includes = [], lex = None):
    """Generate a C++ lexer from a lex file using Flex.

    Args:
      name: The name of the rule.
      src: The .lex source file.
      out: The generated source file.
      includes: A list of headers included by the .lex file.
    """
    cmd = "$(LEX) -o $(@D)/%s $(location %s)" % (out, src)
    if lex != None:
      cmd = "$(location %s) -o $(@D)/%s $(location %s)" % (lex, out, src)
    native.genrule(
        name = name,
        outs = [out],
        srcs = [src] + includes,
        cmd = cmd,
        tools = lex and [lex] or [],
        toolchains = ["@io_kythe//tools/build_rules/lexyacc:current_lexyacc_toolchain"],
    )

def genyacc(name, src, header_out, source_out, extra_outs = [],
            yacc = None):
    """Generate a C++ parser from a Yacc file using Bison.

    Args:
      name: The name of the rule.
      src: The input grammar file.
      header_out: The generated header file.
      source_out: The generated source file.
      extra_outs: Additional generated outputs.
    """
    cmd = "$(YACC) -o $(@D)/%s $(location %s)" % (source_out, src)
    if yacc != None:
      cmd = "$(location %s) -o $(@D)/%s $(location %s)" % (yacc, source_out, src)
    native.genrule(
        name = name,
        outs = [source_out, header_out] + extra_outs,
        srcs = [src],
        cmd = cmd,
        tools = yacc and [yacc] or [],
        toolchains = ["@io_kythe//tools/build_rules/lexyacc:current_lexyacc_toolchain"],
    )

LexYaccInfo = provider(
    doc = "Paths to lex and yacc binaries.",
    fields = ["lex", "yacc"],
)

def _lexyacc_variables(ctx):
    lyinfo = ctx.toolchains["@io_kythe//tools/build_rules/lexyacc:toolchain_type"].lexyaccinfo
    return [
        platform_common.TemplateVariableInfo({
            "LEX": lyinfo.lex,
            "YACC": lyinfo.yacc,
        }),
    ]

lexyacc_variables = rule(
    implementation = _lexyacc_variables,
    toolchains = ["@io_kythe//tools/build_rules/lexyacc:toolchain_type"],
)

def _lexyacc_toolchain_impl(ctx):
    return [
        platform_common.ToolchainInfo(
            lexyaccinfo = LexYaccInfo(
                lex = ctx.attr.lex,
                yacc = ctx.attr.yacc,
            ),
        ),
    ]

_lexyacc_toolchain = rule(
    implementation = _lexyacc_toolchain_impl,
    attrs = {
        "lex": attr.string(),
        "yacc": attr.string(),
    },
    provides = [
        platform_common.ToolchainInfo,
    ],
)

def lexyacc_toolchain(name, lex, yacc):
    _lexyacc_toolchain(name = name, lex = lex, yacc = yacc)
    native.toolchain(
        name = name + "_toolchain",
        toolchain = ":" + name,
        toolchain_type = "@io_kythe//tools/build_rules/lexyacc:toolchain_type",
    )

def _check_flex_version(repository_ctx, min_version):
    flex = repository_ctx.os.environ.get("FLEX", repository_ctx.which("flex"))
    if flex == None:
        fail("Unable to find flex binary")
    flex_result = repository_ctx.execute([flex, "--version"])
    if flex_result.return_code:
        fail("Unable to determine flex version: " + flex_result.stderr)
    flex_version = flex_result.stdout.split(" ")
    if len(flex_version) < 2:
        fail("Too few components in flex version: " + flex_result.stdout)
    if not versions.is_at_least(min_version, flex_version[1]):
        fail("Flex too old (%s < %s)" % (flex_version[1], min_version))
    return flex

def _local_lexyacc(repository_ctx):
    flex = _check_flex_version(repository_ctx, "2.6")
    bison = repository_ctx.os.environ.get("BISON", repository_ctx.which("bison"))
    if not bison:
        fail("Unable to find bison binary")
    repository_ctx.file(
        "WORKSPACE",
        content = "workspace(name=\"%s\")" % (repository_ctx.name,),
        executable = False,
    )
    repository_ctx.file(
        "BUILD.bazel",
        content = "\n".join([
            "load(\"@io_kythe//tools/build_rules/lexyacc:lexyacc.bzl\", \"lexyacc_toolchain\")",
            "package(default_visibility=[\"//visibility:public\"])",
            "lexyacc_toolchain(",
            "  name = \"lexyacc_local\",",
            "  lex = \"%s\"," % flex,
            "  yacc = \"%s\"," % bison,
            ")",
        ]),
    )

local_lexyacc_repository = repository_rule(
    implementation = _local_lexyacc,
    local = True,
    environ = ["PATH", "BISON", "FLEX"],
)

def lexyacc_configure():
    local_lexyacc_repository(name = "local_config_lexyacc")
    native.register_toolchains(
        "@local_config_lexyacc//:lexyacc_local_toolchain",
    )
