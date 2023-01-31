import Toastify from "toastify-js";
import tippy from "tippy.js";

import constants from "../constants";
import helpers from "../helpers";
import { data as todosData } from "../todos/alpine";
import StartToastifyInstance from "toastify-js";

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
      /** Create a tooltip popup. */

      if (!expression) return; // abort if expression is empty

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
// animations
const animations = {
  applyTemporaryStyle(
    elt: HTMLElement,
    temporaryStyles: object,
    options: object
  ) {
    /** Apply temporary, reversible CSS styles. */

    // build options
    const finalOptions = {
      duration: 400,
      transitionDuration: 150,
      repeat: 0,
      ...options,
    };

    // destructure options
    const duration = finalOptions.duration;
    const transitionDuration = finalOptions.transitionDuration;
    const repeat = finalOptions.repeat;

    // remember initial styles
    let initialStyles = {};
    for (const key of Object.keys(temporaryStyles)) {
      initialStyles[key] = elt.style[key];
    }

    const initialTransitionValue = elt.style.transition;

    Promise.resolve()
      .then(() => {
        // apply temporary styles
        if (transitionDuration) {
          // elt.style.transitionDuration = `${transitionDuration}ms`;
          // elt.style.transitionProperty = Object.keys(initialStyles).join(", ");
          elt.style.transition = `all ${transitionDuration}ms`;
        } else {
          elt.style.transition = `none`;
        }

        Object.assign(elt.style, temporaryStyles);
      })
      .then(() => helpers.base.delayFor(duration / 2)) // initial transition
      .then(() => {
        // restore initial styles
        Object.assign(elt.style, initialStyles);
      })
      .then(() => helpers.base.delayFor(duration / 2)) // final transition
      .then(() => {
        // restore initial transition style
        elt.style.transition = initialTransitionValue;

        // loop the animation
        if (repeat) {
          this.applyTemporaryStyle(elt, temporaryStyles, {
            duration,
            transitionDuration: transitionDuration,
            repeat: repeat - 1,
          });
        }
      });
  },

  highlight(elt: HTMLElement, theme: "success", delay: 0) {
    /** Higlight an an element by flashing its background color. */
    const themes = {
      primary: "hsl(var(--p))",
      secondary: "hsl(var(--s))",
      accent: "hsl(var(--a))",
      neutral: "hsl(var(--n))",
      info: "hsl(var(--in))",
      success: "hsl(var(--su))",
      warning: "hsl(var(--wa))",
      error: "hsl(var(--er))",
    };
    const backgroundColor = themes[theme] || themes.primary;
    const opacity = "0.75";

    setTimeout(() => {
      this.applyTemporaryStyle(
        elt,
        { backgroundColor, opacity },
        { repeat: 1 }
      );
    }, delay);
  },

  pop(elt: HTMLElement, iterations: number = 1) {
    /** Create an attention-grabbing 'pop' effect. */
    this.applyTemporaryStyle(elt, { transform: "scale(1.05)" }, { iterations });
  },
};

// toasts
type ProjectToastifyOptions = StartToastifyInstance.Options & {
  content?: string; // use 'content' instead of 'text' for consistency
  theme?:
    | "primary"
    | "secondary"
    | "accent"
    | "neutral"
    | "info"
    | "success"
    | "warning"
    | "error";
};

const toasts = {
  coerceInputs(
    options: string | ProjectToastifyOptions = {}
  ): ProjectToastifyOptions {
    /** Coerce the value of 'options' based on certain factors:
     *  a. If 'options' is a string, convert it to a basic toast options object.
     *      - e.g. "hello" -> { text: "hello" }
     *  b. If 'options' object contains 'content' key, convert it to a 'text'
     *    key. This maintains consistency with the use of the 'content' key
     *    in other areas of this project (tooltips, etc.).
     *      - e.g. { content: "hello"} -> { text: "hello" }
     */
    if (typeof options === "string") {
      // a. Convert string to basic toast object
      options = { text: options } as ProjectToastifyOptions;
    }

    if (options.content) {
      // c. Remap options.content to options.text
      options.text = options.text ?? options.content;
      delete options.content;
    }

    if (!options.text) throw "options['content'|'text'] must not be empty";

    return options;
  },
  hide(toast: any) {
    /** Hide a toast message. */
    toast.hideToast();
  },
  show(options: string | ProjectToastifyOptions = {}) {
    /** Create a new toast message. */
    let toast: any; // create instance placeholder for use in 'hide' callback

    options = this.coerceInputs(options) as ProjectToastifyOptions;

    // themes
    switch (options.theme) {
      case "primary":
        options.style = {
          background: "hsl(var(--p))",
          color: "hsl(var(--pc))",
        };
        break;
      case "secondary":
        options.style = {
          background: "hsl(var(--s))",
          color: "hsl(var(--sc))",
        };
        break;
      case "accent":
        options.style = {
          background: "hsl(var(--a))",
          color: "hsl(var(--ac))",
        };
        break;
      case "neutral":
        options.style = {
          background: "hsl(var(--n))",
          color: "hsl(var(--nc))",
        };
        break;
      case "info":
        options.style = {
          background: "hsl(var(--in))",
          color: "hsl(var(--inc))",
        };
        break;
      case "success":
        options.style = {
          background: "hsl(var(--su))",
          color: "hsl(var(--suc))",
        };
        break;
      case "warning":
        options.style = {
          background: "hsl(var(--wa))",
          color: "hsl(var(--wac))",
        };
        break;
      case "error":
        options.style = {
          background: "hsl(var(--er))",
          color: "hsl(var(--erc))",
        };
        break;
      default:
        options.style = {
          background: "hsl(var(--p))",
          color: "hsl(var(--pc))",
        };
    }

    // create text element
    const textElement = document.createElement("span");
    textElement.className = "toast-text";

    if (options.escapeMarkup) {
      textElement.innerText = options.text as string;
    } else {
      textElement.innerHTML = options.text as string;
    }

    // create toast
    toast = Toastify({
      // text: options.content,
      node: textElement,
      close: true,
      duration: 5000,
      gravity: "bottom",
      onClick: () => this.hide(toast),
      selector: document.querySelector("section#toast-container"),
      ...options,
    } as ProjectToastifyOptions).showToast();

    return toast;
  },
  showPrimary(options: string | ProjectToastifyOptions = {}) {
    /** Create toast message with "primary" theme. */
    options = this.coerceInputs(options) as ProjectToastifyOptions;
    return this.show({ ...options, theme: "primary" });
  },
  showSecondary(options: string | ProjectToastifyOptions = {}) {
    /** Create toast message with "secondary" theme. */
    options = this.coerceInputs(options) as ProjectToastifyOptions;
    return this.show({ ...options, theme: "secondary" });
  },
  showAccent(options: string | ProjectToastifyOptions = {}) {
    /** Create toast message with "accent" theme. */
    options = this.coerceInputs(options) as ProjectToastifyOptions;
    return this.show({ ...options, theme: "accent" });
  },
  showNeutral(options: string | ProjectToastifyOptions = {}) {
    /** Create toast message with "neutral" theme. */
    options = this.coerceInputs(options) as ProjectToastifyOptions;
    return this.show({ ...options, theme: "neutral" });
  },
  showInfo(options: string | ProjectToastifyOptions = {}) {
    /** Create toast message with "info" theme. */
    options = this.coerceInputs(options) as ProjectToastifyOptions;
    return this.show({ ...options, theme: "info" });
  },
  showSuccess(options: string | ProjectToastifyOptions = {}) {
    /** Create toast message with "success" theme. */
    options = this.coerceInputs(options) as ProjectToastifyOptions;
    return this.show({ ...options, theme: "success" });
  },
  showWarning(options: string | ProjectToastifyOptions = {}) {
    /** Create toast message with "warning" theme. */
    options = this.coerceInputs(options) as ProjectToastifyOptions;
    return this.show({ ...options, theme: "warning" });
  },
  showError(options: string | ProjectToastifyOptions = {}) {
    /** Create toast message with "error" theme. */
    options = this.coerceInputs(options) as ProjectToastifyOptions;
    return this.show({ ...options, theme: "error" });
  },
};

export const stores: Array<object> = [
  {
    name: "animations",
    store: animations,
  },
  {
    name: "constants",
    store: constants,
  },
  {
    name: "helpers",
    store: helpers,
  },
  {
    name: "toasts",
    store: toasts,
  },
];
