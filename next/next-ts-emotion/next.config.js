// @ts-check

/**
 * @type {import('next/dist/next-server/server/config-shared').NextConfig}
 **/
const nextConfig = {
  distDir: "next-ts-emotion",
  poweredByHeader: false,
  reactStrictMode: true,
  webpack: (config) => {
    config.watchOptions = {
      aggregateTimeout: 200 /* ms */,
      poll: 500 /* ms */,
    };
    config.resolve = {
      ...config.resolve,
      // avoid escaping the Bazel sandbox
      symlinks: false,
    };
    config.resolveLoader = {
      ...config.resolveLoader,
      // avoid escaping the Bazel sandbox
      symlinks: false,
    };
    return config;
  },
  future: {
    webpack5: true,
  },
  experimental: {},
  async rewrites() {
    return [];
  },
};

module.exports = nextConfig;
