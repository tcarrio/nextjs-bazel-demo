/* eslint-disable @typescript-eslint/no-var-requires */
const { pathsToModuleNameMapper } = require("ts-jest/utils");
const { compilerOptions } = require("../../tsconfig.base");

module.exports = {
  displayName: "next-ts-emotion",
  preset: "../../jest.config.js",
  transform: {
    "^.+\\.(ts|tsx)$": "<rootDir>/../../node_modules/ts-jest",
  },
  transformIgnorePatterns: ["/node_modules/"],
  moduleFileExtensions: ["ts", "tsx", "js", "jsx", "json"],
  setupFilesAfterEnv: ["./setupTests.js"],
  // jail module resolution to workspace node_modules
  moduleDirectories: ["<rootDir>/../../node_modules"],
  moduleNameMapper: {
    ...pathsToModuleNameMapper(compilerOptions.paths, {
      prefix: "<rootDir>/../..",
    }),
  },
  globals: {
    "ts-jest": {
      tsconfig: {
        jsx: "react-jsx",
        jsxImportSource: "@emotion/react",
      },
    },
  },
};
