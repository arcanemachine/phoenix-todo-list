const helpers = {
  alpineExpressionIsObject(expression: string): boolean {
    /** If expression can be evaluated as an object, return true. */
    // expression begins and ends with curly braces
    return expression.substring(0, 1) === "{" && expression.slice(-1) === "}";
  },

  get darkModeEnabled(): boolean {
    if (this.darkModeSavedPreferenceExists) {
      // use saved preference
      return localStorage.getItem("darkModeEnabled") === "1" || false;
    } else {
      // use browser preference
      const browserDarkModePreference = window.matchMedia(
        "(prefers-color-scheme: dark)"
      );

      return browserDarkModePreference.matches;
    }
  },

  get darkModeSavedPreferenceExists(): boolean {
    const lsDarkModePreference = localStorage.getItem("darkModeEnabled");

    if (["0", "1"].includes(String(lsDarkModePreference))) {
      return true;
    } else if (lsDarkModePreference === null) {
      return false;
    } else throw "localStorage.darkModeEnabled must be one of: '0', '1'";
  },

  debug: {
    consoleStatementsWriteToDocument() {
      /** Write console statements directly to the page. Helps debug on mobile. */
      return (function () {
        const prependToBody = (s: string) => {
          const outputEl = document.createElement("div");
          outputEl.textContent = s + "\n";
          document.body.prepend(outputEl);
        };
        console.log = (s) => prependToBody(s);
        console.warn = (s) => prependToBody(s);
        console.error = (s) => prependToBody(s);
      })();
    },
    jsEvaluatorPopupCreate() {
      /** Create a floating element to evaluate arbitrary Javascript. */
      const jsEvaluatorContainer = document.createElement("div");
      jsEvaluatorContainer.innerHTML = `
          <div
            style="position: fixed;
                   height: 2rem; width: 100%;
                   margin-left: 0; margin-right: 0;
                   padding-left: 1rem; padding-right: 1rem;
                   right: 0; bottom: 2rem; left: 0;"
            x-data="{
              evalAlert() { alert(eval($refs.jsEvalInput.value)); },
              evalLog() { console.log(eval($refs.jsEvalInput.value)); },
            }"
          >
            <div style="display: flex; width: 100%;">
              <input
                type="text"
                style="flex-grow: 1;
                       padding-left: 1rem;
                       border-top-left-radius: 0.5rem;
                       border-bottom-left-radius: 0.5rem;"
                placeholder="Enter JS code..."
                x-ref="jsEvalInput"
                x-on:keyup.enter="evalLog"
                autocomplete="off"
              />
              <button
                style="background-color: #88f; padding: 1rem;"
                x-on:click="evalLog"
              >
                Log
              </button>
              <button
                style="background-color: #8c8;
                       padding: 1rem;
                       border-top-right-radius: 0.5rem;
                       border-bottom-right-radius: 0.5rem;"
                x-on:click="evalAlert"
              >
                Alert
              </button>
            </div>
          </div>
        `;
      document.body.appendChild(jsEvaluatorContainer);
    },
  },

  delayFor(timeInMilliseconds: number) {
    /** Create a delay for a specific amount of time. */
    return new Promise(function (resolve) {
      setTimeout(resolve, timeInMilliseconds);
    });
  },

  pluralize(
    count: number,
    baseWord: string,
    nonPluralSuffix = "",
    pluralSuffix = "s"
  ): string {
    /**
     * Given a word and the number of instances (count), return the result
     * in a non-plural or plural format.
     * Examples:
     *   - pluralize("dog", 1) -> "dog"
     *   - pluralize("dog", 2) -> "dogs"
     *   - pluralize("bench", 1) -> "bench"
     *   - pluralize("bench", 2, "", "es") -> "benches"
     *   - pluralize("cherr", 1, "y", "ies") -> "cherry"
     *   - pluralize("cherr", 2, "y", "es") -> "cherries"
     */
    return baseWord + (count === 1 ? nonPluralSuffix : pluralSuffix);
  },
};

export const alpineExpressionIsObject = helpers.alpineExpressionIsObject;
export const darkModeEnabled = helpers.darkModeEnabled;
export const darkModeSavedPreferenceExists =
  helpers.darkModeSavedPreferenceExists;
export const debug = helpers.debug;
export const delayFor = helpers.delayFor;
export const pluralize = helpers.pluralize;

export default helpers;
