const alpineComponents = {
  darkModeToggle() {
    return {
      lightModeToggled: undefined,
      darkModePreference: window.matchMedia("(prefers-color-scheme: dark)"),

      init() {
        const savedDarkModePreferenceExists =
          localStorage.getItem("darkMode") !== null;

        if (!savedDarkModePreferenceExists)
          this.lightModeToggled = !this.darkModePreference.matches;
        // use browser preference
        else {
          // use saved dark mode preference
          this.lightModeToggled = !Boolean(
            JSON.parse(localStorage.getItem("darkMode") || "")
          );
        }

        this.lightModeToggled
          ? this.darkModeDisable(false)
          : this.darkModeEnable(false); // set initial theme

        // watch for changes to dark mode preference
        this.darkModePreference.addEventListener("change", (evt: any) => {
          // only change if no preference has been assigned manually
          if (!savedDarkModePreferenceExists) {
            evt.matches
              ? this.darkModeEnable(false)
              : this.darkModeDisable(false);
          }
        });
      },

      darkModeEnable(updateLocalStorage: boolean) {
        this.lightModeToggled = false;
        updateLocalStorage && localStorage.setItem("darkMode", "1"); // save data to localStorage
        document!.querySelector("html")!.dataset.theme = "luxury"; // set the theme
      },

      darkModeDisable(updateLocalStorage: boolean) {
        this.lightModeToggled = true;
        updateLocalStorage && localStorage.setItem("darkMode", "0"); // save data to localStorage
        document!.querySelector("html")!.removeAttribute("data-theme"); // remove theme data attribute
      },

      darkModeToggle() {
        if (this.lightModeToggled) this.darkModeEnable(true);
        else this.darkModeDisable(true);
      },
    };
  },
};

export default alpineComponents;
