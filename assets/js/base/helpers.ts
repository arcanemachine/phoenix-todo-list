const helpers = (() => {
  return {
    alpineExpressionIsObject(expression: string): boolean {
      /** If expression can be evaluated as an object, return true. */
      // expression begins and ends with curly braces
      return expression.substring(0, 1) === "{" && expression.slice(-1) === "}";
    },

    get darkModeEnabled(): boolean {
      if (this.darkModeSavedPreferenceExists) {
        // use saved preference
        const savedDarkModePreference = JSON.parse(
          localStorage.getItem("darkModeEnabled") || "0"
        );
        return Boolean(savedDarkModePreference);
      } else {
        // use browser preference
        const browserDarkModePreference = window.matchMedia(
          "(prefers-color-scheme: dark)"
        );

        return browserDarkModePreference.matches;
      }
    },

    get darkModeSavedPreferenceExists(): boolean {
      return localStorage.getItem("darkModeEnabled") !== null;
    },

    delayFor(timeInMilliseconds: number) {
      /** Create a delay for a specific amount of time. */
      return new Promise(function (resolve) {
        setTimeout(resolve, timeInMilliseconds);
      });
    },

    pluralize(val: number, nonPluralResult: "", pluralResult = "s"): string {
      return val === 1 ? pluralResult : nonPluralResult;
    },
  };
})();

export const alpineExpressionIsObject = helpers.alpineExpressionIsObject;
export const darkModeEnabled = helpers.darkModeEnabled;
export const darkModeSavedPreferenceExists =
  helpers.darkModeSavedPreferenceExists;
export const delayFor = helpers.delayFor;

export default helpers;
