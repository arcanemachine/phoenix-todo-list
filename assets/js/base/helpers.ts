const helpers = {
  alpineExpressionIsObject(expression: string): boolean {
    /** If expression can be evaluated as an object, return true. */
    return /^{.*}$/.test(expression);
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
  debugShortcut() {
    window.addEventListener("keyup", (evt) => {
      debugger;
    });
  },
};

export default helpers;
