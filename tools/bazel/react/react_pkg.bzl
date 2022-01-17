load("//tools/bazel/typescript:typescript.bzl", "tsx_pkg")

def react_pkg(**kwargs):
    """Defines a React package

    Args:
      **kwargs: Arguments for the underlying ts_pkg rule. See the Bazel TypeScript rules
    """
    options = dict(kwargs)
    options["inclusion_globs"] = kwargs.get("inclusion_globs", [])
    options["deps"] = [
        "//@types/@emotion",
        "//@types/@emotion/react",
        "@npm//@emotion/react",
        "@npm//@types/react",
        "@npm//react",
    ] + kwargs.get("deps", [])

    tsx_pkg(**options)
