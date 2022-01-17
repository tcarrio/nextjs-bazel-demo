import { createSerializer } from "@emotion/jest";
import "@testing-library/jest-dom/extend-expect";

// stable serialization for emotion css classes
expect.addSnapshotSerializer(createSerializer());
