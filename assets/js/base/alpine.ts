import tippy from "tippy.js";

import helpers from "../helpers";
import { delayFor } from "./helpers";
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
const animations = {
  applyTemporaryStyle(elt: HTMLElement, propObj: any, options: object) {
    /** Apply a temporary, reversible style with CSS styles. */

    // build options
    const finalOptions = {
      duration: 500,
      transitionDuration: 250,
      repeat: 0,
      ...options,
    };

    // destructure options
    const duration = finalOptions.duration;
    const transitionDuration = finalOptions.transitionDuration;
    const repeat = finalOptions.repeat;

    const propKey = Object.keys(propObj)[0];
    const propVal = Object.values(propObj)[0];
    const propValInitial = elt.style[propKey];
    const transitionValInitial = elt.style.transition;

    Promise.resolve()
      .then(() => {
        // apply transition style
        if (transitionDuration) {
          elt.style.transition = `${propKey} ${transitionDuration}ms`;
        }

        // apply custom style
        elt.style[propKey] = propVal;
      })
      .then(() => delayFor(duration / 2)) // initial transition
      .then(() => {
        // restore custom style
        elt.style[propKey] = propValInitial;
      })
      .then(() => delayFor(duration / 2)) // final transition
      .then(() => {
        // restore initial transition style
        elt.style.transition = transitionValInitial;

        // loop the animation
        if (repeat) {
          this.applyTemporaryStyle(elt, propObj, {
            duration,
            transitionDuration: transitionDuration,
            repeat: repeat - 1,
          });
        }
      });
  },

  highlight(elt: HTMLElement, theme: "success", delay: 0) {
    /** Flash an element's background color to highlight it. */
    const themes = {
      primary: "#BFDBFE", // blue-200
      success: "#A7F3D0", // emerald-200
    };
    const backgroundColor = themes[theme] || themes.primary;

    setTimeout(() => {
      this.applyTemporaryStyle(
        elt,
        { "background-color": backgroundColor },
        { repeat: 1 }
      );
    }, delay);
  },

  pop(elt: HTMLElement, iterations: number = 1) {
    /** Create a temporary popping effect. */
    this.applyTemporaryStyle(elt, { transform: "scale(1.05)" }, { iterations });
  },
};

export const stores: Array<object> = [
  // {
  //   name: "helloWorld",
  //   store: "Hello World!",
  // },
  {
    name: "animations",
    store: animations,
  },
];
