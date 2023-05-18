(() => {
  const darkModeEnabled = (() => {
    const darkModeSavedPreferenceExists =
      localStorage.getItem("darkModeEnabled") !== null;

    if (darkModeSavedPreferenceExists) {
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
  })();

  document.querySelector("html").dataset.theme = darkModeEnabled
    ? "dark"
    : "default";
})();
