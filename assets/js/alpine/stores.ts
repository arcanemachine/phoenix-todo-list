const helpers = {
  get darkModeSavedPreferenceExists() {
    return localStorage.getItem("darkModeEnabled") !== null;
  },
};

const stores = [
  {
    name: "darkModeEnabled",
    store: (() => {
      if (helpers.darkModeSavedPreferenceExists) {
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
    })(),
  },
  {
    name: "helpers",
    store: helpers,
  },
];

export default stores;
