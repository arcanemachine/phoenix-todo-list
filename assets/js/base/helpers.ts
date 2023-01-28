export function alpineExpressionIsObject(expression: string): boolean {
  /** If expression can be evaluated as an object, return true. */
  return /^{.*}$/.test(expression);
}

export function darkModeEnabled(): boolean {
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
}

export function darkModeSavedPreferenceExists(): boolean {
  return localStorage.getItem("darkModeEnabled") !== null;
}

export function delay(timeInMilliseconds: number) {
  /** Create a delay for a specific amount of time. */
  return new Promise(function (resolve) {
    setTimeout(resolve, timeInMilliseconds);
  });
}

export function phxAfterLoading(eventType: string, callback: Function) {
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
}

const helpers = {
  alpineExpressionIsObject,
  darkModeEnabled,
  delay,
  darkModeSavedPreferenceExists,
  phxAfterLoading,
};

export default helpers;
