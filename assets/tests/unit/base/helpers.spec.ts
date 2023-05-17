// @vitest-environment jsdom
import { describe, expect, test } from "vitest";

import helpers from "js/base/helpers";

describe("alpineExpressionIsObject", () => {
  test("returns true if an expression can be evaluated as an object", () => {
    const expression = "{ key: 'value' }";

    expect(helpers.alpineExpressionIsObject(expression)).toBe(true);
  });

  test("returns true if an expression cannot be evaluated as an object", () => {
    const expression = "expresssion";

    expect(helpers.alpineExpressionIsObject(expression)).toBe(false);
  });
});
