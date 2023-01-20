const stores = [
  {
    name: "darkModeEnabled",
    get store() {
      const savedDarkModePreferenceExists =
        localStorage.getItem("darkModeEnabled") !== null;

      if (savedDarkModePreferenceExists) {
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
  },
];

export default stores;
