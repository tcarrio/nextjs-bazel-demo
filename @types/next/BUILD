load("//tools/bazel:index.bzl", "definitions")

package(default_visibility = ["//:__subpackages__"])

filegroup(
    name = "next_types",
    srcs = glob(
        ["*.d.ts"],
    ),
)

definitions(
    name = "next",
    defs = [":next_types"],
    deps = [],
)
