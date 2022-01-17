load("//tools/bazel:index.bzl", "definitions")

package(default_visibility = ["//:__subpackages__"])

filegroup(
    name = "emotion_types",
    srcs = glob(
        ["*.d.ts"],
    ),
)

definitions(
    name = "@emotion",
    defs = [":emotion_types"],
    deps = [],
)
