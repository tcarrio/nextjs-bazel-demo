"""
Expose all TypeScript rules
"""

load(":ts_pkg.bzl", _ts_pkg = "ts_pkg")
load(":tsx_pkg.bzl", _tsx_pkg = "tsx_pkg")
load(":definitions.bzl", _definitions = "definitions")

ts_pkg = _ts_pkg
tsx_pkg = _tsx_pkg
definitions = _definitions