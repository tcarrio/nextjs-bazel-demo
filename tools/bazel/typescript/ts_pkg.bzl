load("@build_bazel_rules_nodejs//:index.bzl", "js_library", "nodejs_binary")
load("@npm//@bazel/typescript:index.bzl", "ts_config", "ts_project")
load("//:project.bzl", "WORKSPACE_NAME")
load("//tools/bazel/util:index.bzl", "dedup")

VALID_PACKAGE_TYPES = ["app", "lib"]
VALID_RUNTIME_TYPES = ["browser", "node"]

def ts_pkg(
        name,
        type,
        deps,
        module_name = None,
        no_module_name = False,
        entry_point = "main.ts",
        exclusion_globs = [],
        inclusion_globs = [],
        custom_tsconfig = None,
        preserve_jsx = False,
        bundle = False,
        runtime_environment = "node",
        eslintrc = None,
        data = [],
        args = [],
        env = {}):
    """Defines a TypeScript package

    Args:
      name: name of the package
      module_name: name of the module
      no_module_name: Don't give the package a module name
      type: "app" or "lib"
      deps: dependencies
      entry_point: Entrypoint for application, if package is an app
      exclusion_globs: Globs for exclusion from the ts_library source
      inclusion_globs: Globs for inclusion to the ts_library source
      custom_tsconfig: A custom tsconfig target, if necessary
      preserve_jsx: Whether jsx is set to "preserve" in the tsconfig
      bundle: whether to bundle
      runtime_environment: The runtime environment for the library (browser or node)
      eslintrc: A package-specific eslintrc
      data: Runtime data for apps
      args: Arguments for apps
      env: Runtime environment variables for apps
    """
    if type not in VALID_PACKAGE_TYPES:
        fail("Only app and lib packages are currently supported, given type was: %s" % type)

    if runtime_environment not in VALID_RUNTIME_TYPES:
        fail("Only browser and node runtimes are currently supported, given type was: %s" % runtime_environment)

    pkg_name = name if type == "lib" else "%s_lib" % name
    module_name = module_name if module_name != None else name

    deps = dedup(deps + ["@npm//tslib", "@npm//@types/node"])

    ts_project(
        name = "%s_compiled" % pkg_name,
        srcs = native.glob(
            include = ["**/*.ts"] + inclusion_globs,
            exclude = ["**/*.spec.ts", "**/*.test.ts", "**/jest.*"] + exclusion_globs,
        ),
        tsconfig = custom_tsconfig if (custom_tsconfig != None) else ":tsconfig_%s" % type,
        deps = deps,
        declaration = True,
        source_map = True,
        composite = True,
        preserve_jsx = preserve_jsx,
    )

    js_library(
        name = pkg_name,
        package_name = "@%s/%s" % (WORKSPACE_NAME, module_name),
        visibility = ["//:__subpackages__"],
        deps = ["%s_%s" % (pkg_name, "compiled" if bundle == False else "bundle")],
    )

    if custom_tsconfig == None:
        ts_config(
            name = "tsconfig_%s" % type,
            src = ":tsconfig.%s.json" % type,
            deps = [
                ":tsconfig.json",
                "//:tsconfig.base.json",
            ],
        )

    if type == "app":
        templated_args = []

        templated_args.extend(args)

        # When a package is missing a module name, paths will look like
        # workspace/apps/app-service/.../.js instead of
        # @workspace/app-service/.../.js.
        #
        # This will patch the require function using
        # ${TARGET_NAME}_require_patch.js so that Bazel can resolve
        # the workspace/... paths. Otherwise, the linker is used and
        # the @workspace/... packages are linked in the node_modules.
        if no_module_name != None:
            templated_args.insert(0, "--bazel_patch_module_resolver")

        nodejs_binary(
            name = name,
            data = [
                ":%s" % pkg_name,
            ] + data,
            entry_point = entry_point,
            env = env,
            templated_args = templated_args,
        )

    native.filegroup(
        name = "%s_srcs" % name,
        srcs = native.glob(
            include = ["**/*.ts"] + inclusion_globs,
            exclude = ["**/*.spec.ts", "**/*.test.ts"] + exclusion_globs,
        ),
    )
