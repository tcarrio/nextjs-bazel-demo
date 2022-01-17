import Head from "next/head";
import React from "react";

export function IndexPage() {
  return (
    <div>
      <Head>
        <title>Home Page</title>
        <meta
          name="description"
          content="The home page."
        />
      </Head>
      <main>
        <h1>Welcome home.</h1>
      </main>
    </div>
  );
}

export default IndexPage;
