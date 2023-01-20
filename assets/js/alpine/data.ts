const data = [
  {
    name: "darkModeToggle",
    data() {
      return {
        lightModeToggled: undefined,

        init() {
          this.lightModeToggled = !this.$store.darkModeEnabled;

          // set initial theme
          if (this.lightModeToggled) this.darkModeDisable(false);
          else this.darkModeEnable(false);

          // watch for changes to dark mode preference
          const browserDarkModePreference = window.matchMedia(
            "(prefers-color-scheme: dark)"
          );
          browserDarkModePreference.addEventListener("change", (evt: any) => {
            // only change if no preference has been assigned manually
            if (!this.$store.helpers.darkModeSavedPreferenceExists) {
              evt.matches
                ? this.darkModeEnable(false)
                : this.darkModeDisable(false);
            }
          });
        },

        darkModeEnable(updateLocalStorage: boolean) {
          this.$store.darkModeEnabled = true;
          this.lightModeToggled = !this.$store.darkModeEnabled;

          // save data to localStorage and set the theme
          updateLocalStorage && localStorage.setItem("darkModeEnabled", "1");
          document!.querySelector("html")!.dataset.theme = "dark";
        },

        darkModeDisable(updateLocalStorage: boolean) {
          this.$store.darkModeEnabled = false;
          this.lightModeToggled = !this.$store.darkModeEnabled;

          // save data to localStorage and reset the theme
          updateLocalStorage && localStorage.setItem("darkModeEnabled", "0");
          document!.querySelector("html")!.dataset.theme = "default";
        },

        darkModeToggle() {
          if (this.lightModeToggled) this.darkModeEnable(true);
          else this.darkModeDisable(true);
        },
      };
    },
  },
];

export default data;
