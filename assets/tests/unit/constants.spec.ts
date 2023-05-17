import { expect, test } from "vitest";

import constants from "js/constants";

test("constants", () => {
  expect(constants.transitionDurationDefault).toBe(500);
});
