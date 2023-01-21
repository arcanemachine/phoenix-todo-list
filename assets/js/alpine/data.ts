import projectHelpers from "../helpers";

const data = [
  {
    name: "darkModeToggle",
    data() {
      return {
        lightModeToggled: !projectHelpers.darkModeEnabled,

        init() {
          // watch for changes to dark mode preference
          const browserDarkModePreference = window.matchMedia(
            "(prefers-color-scheme: dark)"
          );
          browserDarkModePreference.addEventListener("change", (evt: any) => {
            // only change if no preference has been assigned manually
            if (!projectHelpers.darkModeSavedPreferenceExists) {
              evt.matches
                ? this.darkModeEnable(false)
                : this.darkModeDisable(false);
            }
          });
        },

        darkModeEnable(updateLocalStorage: boolean) {
          // this.$store.darkModeEnabled = true;
          // this.lightModeToggled = !this.$store.darkModeEnabled;
          this.lightModeToggled = false;

          // save data to localStorage and set the theme
          if (updateLocalStorage) localStorage.setItem("darkModeEnabled", "1");
          document!.querySelector("html")!.dataset.theme = "dark";
        },

        darkModeDisable(updateLocalStorage: boolean) {
          // this.$store.darkModeEnabled = false;
          // this.lightModeToggled = !this.$store.darkModeEnabled;
          this.lightModeToggled = true;

          // save data to localStorage and reset the theme
          if (updateLocalStorage) localStorage.setItem("darkModeEnabled", "0");
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
