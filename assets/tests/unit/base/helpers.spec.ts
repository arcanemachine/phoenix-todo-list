// @vitest-environment jsdom
import { describe, expect, it } from "vitest";

import helpers from "js/base/helpers";

const initialValue = "initialValue";
const finalValue = "finalValue";

describe("alpineExpressionIsObject", () => {
  it("returns true if an expression can be evaluated as an object", () => {
    const expression = "{ key: 'value' }";
    expect(helpers.alpineExpressionIsObject(expression)).toBe(true);
  });

  it("returns true if an expression cannot be evaluated as an object", () => {
    const expression = "expresssion";
    expect(helpers.alpineExpressionIsObject(expression)).toBe(false);
  });
});

describe("darkModeEnabled", () => {
  it("returns true if localStorage.darkModeEnabled is '1'", () => {
    localStorage.setItem("darkModeEnabled", "1");

    expect(helpers.darkModeEnabled).toBe(true);
  });

  it("returns false if localStorage.darkModeEnabled is not '1'", () => {
    // "0"
    localStorage.setItem("darkModeEnabled", "0");
    expect(helpers.darkModeEnabled).toBe(false);

    // null
    localStorage.removeItem("darkModeEnabled");
    expect(helpers.darkModeEnabled).toBe(false);

    // arbitrary string
    localStorage.removeItem("arbitraryString");
    expect(helpers.darkModeEnabled).toBe(false);
  });
});

describe("darkModeSavedPreferenceExists", () => {
  it("returns true if localStorage.darkModeEnabled equals '1'", () => {
    // 1
    localStorage.setItem("darkModeEnabled", "1");
    expect(helpers.darkModeSavedPreferenceExists).toBe(true);
  });

  it("returns true if localStorage.darkModeEnabled equals '0'", () => {
    // 1
    localStorage.setItem("darkModeEnabled", "0");
    expect(helpers.darkModeSavedPreferenceExists).toBe(true);
  });

  it("returns false if localStorage.darkModeEnabled is null", () => {
    localStorage.removeItem("darkModeEnabled");

    expect(helpers.darkModeSavedPreferenceExists).toBe(false);
  });

  it("throws expected exception if localStorage.darkModeEnabled is not one of: null, '0', '1'", () => {
    localStorage.setItem("darkModeEnabled", "arbitraryString");

    expect(() => helpers.darkModeSavedPreferenceExists).toThrow(
      "localStorage.darkModeEnabled must be one of: '0', '1'"
    );
  });
});

describe("delayFor", () => {
  it("performs an action after a certain amount of time", async () => {
    let testValue = initialValue;

    // create a delay, then set a new value
    const result = helpers.delayFor(10).then(() => {
      testValue = finalValue; // set new value after the delay
    });

    expect(testValue).toBe(initialValue); // the value doesn't change immediately

    // the value doesn't change before the expected delay
    await helpers.delayFor(5).then(() => {
      expect(testValue).toBe(initialValue);
    });

    await result; // wait for the delay to be completed
    expect(testValue).toBe(finalValue); // assert expected value
  });
});

describe("pluralize", () => {
  const regularWordSingular = "dog";
  const regularWordPlural = "dogs";
  const regularWordArgs = [regularWordSingular];

  const irregularWordSingular = "cherry";
  const irregularWordPlural = "cherries";
  const irregularWordArgs = ["cherr", "y", "ies"];

  it("does not pluralize a regular word with a count equal to 1", () => {
    // @ts-ignore 2556: spread operator works as expected
    const result = helpers.pluralize(1, ...regularWordArgs);
    expect(result).toBe(regularWordSingular);
  });

  it("does not pluralize an irregular word with a count equal to 1", () => {
    // @ts-ignore 2556: spread operator works as expected
    const result = helpers.pluralize(1, ...irregularWordArgs);
    expect(result).toBe(irregularWordSingular);
  });

  it("pluralizes a regular word with a count not equal to 1", () => {
    // @ts-ignore 2556: spread operator works as expected
    const result = helpers.pluralize(2, ...regularWordArgs);
    expect(result).toBe(regularWordPlural);
  });

  it("pluralizes an irregular word with a count not equal to 1", () => {
    // @ts-ignore 2556: spread operator works as expected
    const result = helpers.pluralize(2, ...irregularWordArgs);
    expect(result).toBe(irregularWordPlural);
  });
});
