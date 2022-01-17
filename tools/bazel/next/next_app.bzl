"""
Next.js application macro.

Taken from here: https://github.com/bazelbuild/rules_nodejs/pull/2577
"""

load("@build_bazel_rules_nodejs//:index.bzl", "copy_to_bin", "directory_file_path", "npm_package_bin")
load("@io_bazel_rules_docker//nodejs:image.bzl", "nodejs_image")
load("@npm//next:index.bzl", "next")
load(":next_pkg.bzl", "next_pkg")

BAZEL_OPTIONS = [
    # We need to preserve (as opposed to resolving) symlinks to ensure that
    # Webpack doesn't escape the execroot, which could cause issues with
    # resolving React libraries to different paths.
    "--node_options=--preserve-symlinks-main",
    # Next would normally be run from the runfiles directory, which causes
    # problems with resolving a single version of React. Usually the
    # dependencies needed for the CLI will resolve to the node_modules directory
    # in the runfiles, while the dependencies for the app that is being built
    # will resolve to the one in the execroot. Therefore we run in the execroot
    # to get the same view of the node_modules for the CLI and the app.
    "--bazel_run_from_execroot",
]

APP_DEPENDENCIES = [
    "//:package.json",
    "//:tsconfig_base_bin",
    "//@types/next",
]

def next_app(name, deps = [], runtime_deps = [], port = 3000, legacy_babelrc = False, telemetry = False):
    """Macro to define a Next.js application

    Next requries that all files are within the same directory, so we have to
    copy any source files needed for an execution into the Bazel output.

    Args:
        name: The name of the application
        deps: Dependencies
        runtime_deps: Runtime dependencies for the container
        port: String port to use for local development
        legacy_babelrc: Include the package's .babelrc
        telemetry: Whether to allow telemetry from Next.js
    """
    inputs = "%s-srcs" % name
    native.filegroup(
        name = inputs,
        srcs = native.glob(
            include = [
                "**/*.tsx",
                "**/*.ts",
            ],
            exclude = [
                ".next/**",
                "tests/**",
                "**/*.spec.ts",
                "**/*.spec.tsx",
                "jest.setup.ts",
            ],
        ),
    )

    native.filegroup(
        name = "public_files",
        srcs = native.glob(["public/**"]),
    )

    copy_to_bin(
        name = "dotenv_bin",
        srcs = [".env"],
    )

    copy_to_bin(
        name = "config_bin",
        srcs = ["next.config.js"] + [".babelrc"] if legacy_babelrc else [],
    )

    bin_inputs = "%s-bin" % name
    copy_to_bin(name = bin_inputs, srcs = [inputs])
    copy_to_bin(name = "public_files_bin", srcs = ["public_files"])

    # Enable/disable Next.js Telemetry
    telemetry_value = "0" if telemetry else "1"

    next_pkg(
        name = "ts_build",
        module_name = name,
        type = "app",
        deps = deps,
        preserve_jsx = False,
        runtime_environment = "browser",
    )

    data = [
        bin_inputs,
        ":tsconfig_bin",
        "//:tsconfig_base_bin",
        "config_bin",
        "public_files_bin",
    ] + deps

    npm_package_bin(
        name = name,
        package = "next",
        data = data,
        output_dir = True,
        env = {
            "NEXT_TELEMETRY_DISABLED": telemetry_value,
        },
        args = ["build", "$(RULEDIR)"] + BAZEL_OPTIONS,
    )

    copy_to_bin(
        name = "tsconfig_bin",
        srcs = [
            ":tsconfig.json",
        ],
    )

    next(
        name = "dev",
        data = data + [
            ":dotenv_bin",
        ],
        templated_args = ["dev", native.package_name(), "-p", port] + BAZEL_OPTIONS,
        env = {
            "NEXT_TELEMETRY_DISABLED": telemetry_value,
        },
        # Enables IBazel file update handling for triggering dev server rebuilds
        # on changes in the source or dependencies
        tags = ["ibazel_notify_changes"],
    )

    directory_file_path(
        name = "next_bin",
        directory = "@npm//:node_modules/next",
        path = "dist/bin/next",
    )

    nodejs_image(
        name = "image",
        # NOTE: Next.js renders some content at runtime, so some additional Node modules will be needed
        data = [
            name,
            ":config_bin",
            "@npm//next-logger",
            "public_files_bin",
        ] + deps,
        entry_point = "next_bin",
        env = {
            # NOTE: Injects the Next logger for custom logging access
            "NODE_OPTIONS": "\"-r $RUNFILES/npm/node_modules/next-logger\"",
        },
        templated_args = [
            "--bazel_patch_module_resolver",
            "start",
            # Next.js wants the output folder in the current working directory.
            "$(rootpath %s)/../" % name,
        ],
    )
