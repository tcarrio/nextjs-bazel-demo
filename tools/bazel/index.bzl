"""
Make all Bazel rules available from the root //tools/bazel
"""

load("//tools/bazel/typescript:typescript.bzl", _definitions = "definitions", _ts_pkg = "ts_pkg", _tsx_pkg = "tsx_pkg")
load("//tools/bazel/react:react.bzl", _react_pkg = "react_pkg")
load("//tools/bazel/next:next.bzl", _next_app = "next_app", _next_pkg = "next_pkg")

definitions = _definitions
ts_pkg = _ts_pkg
tsx_pkg = _tsx_pkg
react_pkg = _react_pkg
next_app = _next_app
next_pkg = _next_pkg
