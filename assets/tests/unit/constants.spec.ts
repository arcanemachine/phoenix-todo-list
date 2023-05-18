import { describe, expect, it } from "vitest";

import constants from "js/constants";

describe("constants", () => {
  it("has expected values", () => {
    expect(constants.transitionDurationDefault).toBe(500);
  });
});
