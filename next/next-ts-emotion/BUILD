load("//tools/bazel:index.bzl", "next_app")

package(default_visibility = ["//:__subpackages__"])

RUNTIME_DEPS = [
    "@npm//@emotion/css",
    "@npm//@emotion/react",
    "@npm//@emotion/styled",
    "@npm//next",
]

NPM_DEPS = [
    "@npm//@emotion/babel-plugin",
    "@npm//@emotion/css",
    "@npm//@emotion/react",
    "@npm//@emotion/styled",
    "@npm//react",
    "@npm//react-aria",
    "@npm//react-dom",
    "@npm//typescript",
]

MONOREPO_DEPS = []

next_app(
    name = "next-ts-emotion",
    port = "3002",
    runtime_deps = RUNTIME_DEPS,
    deps = NPM_DEPS + MONOREPO_DEPS,
    legacy_babelrc = True,
)
