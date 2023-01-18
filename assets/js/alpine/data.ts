const alpineData = [
  {
    name: "darkModeToggle",
    data() {
      return {
        lightModeToggled: undefined,
        darkModePreference: window.matchMedia("(prefers-color-scheme: dark)"),

        init() {
          const savedDarkModePreferenceExists =
            localStorage.getItem("darkMode") !== null;

          if (!savedDarkModePreferenceExists)
            // use browser preference
            this.lightModeToggled = !this.darkModePreference.matches;
          else {
            // use saved preference
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

          // save data to localStorage and set the theme
          updateLocalStorage && localStorage.setItem("darkMode", "1");
          document!.querySelector("html")!.dataset.theme = "luxury";
        },

        darkModeDisable(updateLocalStorage: boolean) {
          this.lightModeToggled = true;

          // save data to localStorage and reset the theme
          updateLocalStorage && localStorage.setItem("darkMode", "0");
          document!.querySelector("html")!.removeAttribute("data-theme");
        },

        darkModeToggle() {
          if (this.lightModeToggled) this.darkModeEnable(true);
          else this.darkModeDisable(true);
        },
      };
    },
  },
];

export default alpineData;
