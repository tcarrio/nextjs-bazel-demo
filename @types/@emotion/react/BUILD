load("//tools/bazel:index.bzl", "definitions")

package(default_visibility = ["//:__subpackages__"])

filegroup(
    name = "react_types",
    srcs = glob(
        ["*.d.ts"],
    ),
)

definitions(
    name = "react",
    defs = [":react_types"],
    deps = [],
)
