// NOTE: Override svg import types
/* eslint-disable @typescript-eslint/no-explicit-any */
declare module "*.svg" {
  const content: any;
  export const ReactComponent: any;
  export default content;
}

// NOTE: Override Web Component JSX types
declare namespace JSX {
  interface IntrinsicElements {
    "custom-web-component": unknown;
  }
}
