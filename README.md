# nextjs-bazel-demo

This app setups up a basic Next.js app with Bazel.

## bazel rules

The beef of the Bazel logic for implementing the Next.js app is in the
`/bazel/next` directory. It is possible to define both Next apps and Next
packages. Next packages are reusable packages that use `next` libraries,
such as `next/router` and `next/link`. Next apps can be run and have a
dev server option, along with all of the functionality as Next packages
as well.
