load("//tools/bazel/react:react.bzl", "react_pkg")

def next_pkg(**kwargs):
    """Defines a NextJS package

    Args:
      **kwargs: Arguments for the underlying ts_pkg rule. See the Bazel TypeScript rules
    """
    options = dict(kwargs)
    options["inclusion_globs"] = kwargs.get("inclusion_globs", [])
    options["deps"] = [
        "//@types/next",
        "@npm//next",
    ] + kwargs.get("deps", [])

    react_pkg(**options)
