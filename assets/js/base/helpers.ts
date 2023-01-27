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
  phxAfterLoading(eventType: string, callback: Function) {
    /** When loading event has ended, execute a callback. */
    this.$nextTick().then(() => {
      const timer = setInterval(() => {
        if (this.$el.classList.contains(`phx-${eventType}-loading`)) {
          return;
        } else {
          clearInterval(timer);
          callback.bind(this)();
        }
      }, 100);
    });
  },
};

export default helpers;
