load("@build_bazel_rules_nodejs//:index.bzl", "copy_to_bin")
load("@bazel_skylib//rules:common_settings.bzl", "bool_flag", "string_flag")

package(default_visibility = ["//:__subpackages__"])

# Set with --config=production
# can be used to create config_settings
# https://docs.bazel.build/versions/master/configurable-attributes.html#custom-flags
string_flag(
    name = "environment",
    build_setting_default = "development",
    values = [
        "production",
        "development",
    ],
)

# Set with --config=ci
# set to determine if the environment is CI (different browsers for e2e testing)
bool_flag(
    name = "ci",
    build_setting_default = False,
)

# Set with --config=debug
# can be used to emit additional debug output
# https://docs.bazel.build/versions/master/configurable-attributes.html#custom-flags
bool_flag(
    name = "debug",
    build_setting_default = False,
)

# Allow any ts_library rules in this workspace to reference the config
exports_files([
    ".eslintrc.json",
    ".prettierrc",
    "tsconfig.base.json",
    "tsconfig.eslint.json",
    "package.json",
    ".env",
    ".env.example",
])

copy_to_bin(
    name = "tsconfig_base_bin",
    srcs = [":tsconfig.base.json"],
)
