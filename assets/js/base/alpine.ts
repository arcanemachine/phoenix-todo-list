import tippy from "tippy.js";

import helpers from "../helpers";
import { data as todosData } from "../todos/alpine";

/* data */
function darkModeToggle() {
  return {
    lightModeToggled: !helpers.base.darkModeEnabled,

    init() {
      // watch for changes to dark mode preference
      const browserDarkModePreference = window.matchMedia(
        "(prefers-color-scheme: dark)"
      );
      browserDarkModePreference.addEventListener("change", (evt: any) => {
        // only change if no preference has been assigned manually
        if (!helpers.base.darkModeSavedPreferenceExists) {
          evt.matches
            ? this.darkModeEnable(false)
            : this.darkModeDisable(false);
        }
      });
    },

    darkModeEnable(updateLocalStorage: boolean) {
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
}

export const data = [
  {
    name: "darkModeToggle",
    data: darkModeToggle,
  },
  ...todosData,
];

/* directives */
export const directives = [
  {
    name: "tooltip",
    directive(
      elt: HTMLElement,
      { expression }: any,
      { evaluate, cleanup }: any
    ) {
      const defaultOptions = {
        delay: [750, null],
        interactiveDebounce: 150,
        touch: ["hold", 500],
      };

      // parse expression and convert to object
      let options: Record<string, any>;
      if (helpers.base.alpineExpressionIsObject(expression)) {
        options = evaluate(expression); // expression is an object
      } else {
        options = { content: expression }; // convert expression to object
      }

      // finalized options
      options = {
        ...defaultOptions,
        ...options,
      };

      // create tooltip
      const tip = tippy(elt, options);

      // when element is removed from the DOM, destroy the tooltip
      cleanup(() => {
        tip.destroy();
      });
    },
  },
];

/* stores */
export const stores: Array<object> = [
  // {
  //   name: "helloWorld",
  //   store: "Hello World!",
  // },
];
