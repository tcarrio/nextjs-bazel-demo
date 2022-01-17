load(":ts_pkg.bzl", "ts_pkg")

def tsx_pkg(**kwargs):
    """Defines a TSX package

    Args:
      **kwargs: Arguments for the underlying ts_pkg rule. See the Bazel TypeScript rules
    """
    options = dict(kwargs)
    options["inclusion_globs"] = kwargs.get("inclusion_globs", []) + ["**/*.tsx"]
    options["preserve_jsx"] = options.get("preserve_jsx") if "preserve_jsx" in options else False
    ts_pkg(**options)
