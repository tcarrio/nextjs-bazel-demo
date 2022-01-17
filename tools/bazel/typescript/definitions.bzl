load("@build_bazel_rules_nodejs//:providers.bzl", "declaration_info")

def _definitions_impl(ctx):
    return [
        declaration_info(depset(ctx.files.defs), ctx.attr.deps),
    ]

definitions = rule(
    implementation = _definitions_impl,
    attrs = {
        "defs": attr.label_list(
            mandatory = True,
            doc = "TypeScript definition files",
        ),
        "deps": attr.label_list(
            mandatory = True,
            doc = "NPM dependencies",
        ),
    },
)
