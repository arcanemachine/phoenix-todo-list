import Alpine from "alpinejs";
import Toastify from "toastify-js";
import tippy from "tippy.js";

import type { AlpineComponent, AlpineStore } from "js/alpine";
import constants from "js/constants";
import h from "js/helpers";
import { data as todosData } from "js/todos/alpine";

/* data */
function darkModeSelect() {
  return {
    // data
    choice: (): string => {
      /** Get initial choice. */
      if (h.base.darkModeSavedPreferenceExists) {
        return localStorage.getItem("darkModeEnabled") === "1"
          ? "Dark"
          : "Light";
      } else return "Auto";
    },

    // lifecycle
    init() {
      // watch for changes to dark mode preference
      const browserDarkModePreference = window.matchMedia(
        "(prefers-color-scheme: dark)"
      );

      // set initial theme
      if (
        !h.base.darkModeSavedPreferenceExists &&
        browserDarkModePreference.matches
      ) {
        this.darkModeEnable(false);
      }

      // watch for browser-level changes to dark mode preference
      browserDarkModePreference.addEventListener("change", (evt: any) => {
        // only change if no preference has been assigned manually
        if (!h.base.darkModeSavedPreferenceExists) {
          evt.matches
            ? this.darkModeEnable(false)
            : this.darkModeDisable(false);
        }
      });
    },

    // methods
    darkModeClearPreference() {
      // set the theme
      const browserDarkModePreference = window.matchMedia(
        "(prefers-color-scheme: dark)"
      );
      if (browserDarkModePreference.matches) {
        this.darkModeEnable(false);
      } else {
        this.darkModeDisable(false);
      }

      // remove saved preference
      localStorage.removeItem("darkModeEnabled");
    },

    darkModeEnable(updateSavedPreference: boolean) {
      // set the theme
      document!.querySelector("html")!.dataset.theme = "dark";

      if (updateSavedPreference) {
        // save data to localStorage
        localStorage.setItem("darkModeEnabled", "1");
      }
    },

    darkModeDisable(updateSavedPreference: boolean) {
      // set the theme
      document!.querySelector("html")!.dataset.theme = "default";

      if (updateSavedPreference) {
        // save data to localStorage
        localStorage.setItem("darkModeEnabled", "0");
      }
    },

    handleChange() {
      const choice = this.choice as unknown as string;

      if (choice === "Auto") {
        this.darkModeClearPreference();
      } else if (choice === "Light") {
        this.darkModeDisable(true);
      } else if (choice === "Dark") {
        this.darkModeEnable(true);
      }
    },
  };
}

export const data = [
  {
    name: "darkModeSelect",
    data: darkModeSelect,
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
      if (h.base.alpineExpressionIsObject(expression)) {
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

      // add 'aria-label' attribute to improve accessibility
      elt.setAttribute("aria-label", options.content);

      // when element is removed from the DOM, destroy the tooltip
      cleanup(() => {
        tip.destroy();
      });
    },
  },
  {
    name: "page-title",
    directive(_elt: HTMLElement, { expression }: any) {
      /** Workaround: Updates the `#page-title` element. Fixes issue with
       *  LiveView navigation not updating the title properly.
       */
      document.querySelector("#page-title")!.textContent = expression;
    },
  },
];

/* helpers */
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
      transitionDuration: 100,
      repeat: 0,
      ...options,
    };

    // destructure options
    const duration = finalOptions.duration;
    const transitionDuration = finalOptions.transitionDuration;
    const repeat = finalOptions.repeat;

    // remember initial styles
    let initialStyles: Record<string, string> = {}; // use record to keep ts linter quiet
    const style = Object(elt.style); // convert to object to keep ts linter quiet
    for (let key of Object.keys(temporaryStyles)) {
      initialStyles[key] = style[key];
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
      .then(() => h.base.delayFor(duration / 2)) // initial transition
      .then(() => {
        // restore initial styles
        Object.assign(elt.style, initialStyles);
      })
      .then(() => h.base.delayFor(duration / 2)) // final transition
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

const components = {
  body: () => {
    return {
      init() {
        // this.$store.components.body = this;
        this.$el.setAttribute("x-title", "body");

        /* set global values */
        // const globals = this.$store.globals;

        // auth
        this.$store.globals.userIsAuthenticated = JSON.parse(
          this.$el.dataset.userIsAuthenticated
        );
      },
    } as AlpineComponent;
  },
  // showOnInit: () => {
  //   return {
  //     show: false,

  //     bindings: {
  //       ["x-transition.opacity.duration.500ms"]() {
  //         return this.show;
  //       },
  //     },

  //     init() {
  //       this.$el.setAttribute("x-bind", "bindings");

  //       setTimeout(() => {
  //         this.show = true;
  //       });
  //     },
  //   };
  // },
  simpleForm: () => {
    const dataConfirmationRequired = {
      /** If a form requires confirmation, show a checkbox element at the
       *  bottom of the form, and do not allow the form to be submitted
       *  unless the checkbox has been checked. This is intended to prevent
       *  users from unintentionally submitting the form.
       */
      confirmationRequired: undefined,
      confirmed: false,

      init() {
        this.confirmationRequired = this.$el.dataset.confirmationRequired;
      },
    } as AlpineComponent;

    const dataFormModifiedAlertOnExit = {
      /** If a form has been modified, show a warning when exiting the page
       *  before the form has been submitted.
       */

      defaultValue: "defaultValue",
      modifiedInputs: new Set(),

      init() {
        // // initialize modified input fields
        // this.modifiedInputs = new Set();

        // add event listeners
        addEventListener("beforeinput", this.handleBeforeInput.bind(this));
        addEventListener("input", this.handleInput.bind(this) as any);
        addEventListener("submit", this.handleSubmit.bind(this));
        addEventListener("beforeunload", this.handleBeforeUnload.bind(this));
      },

      destroy() {
        // clear modified input fields
        this.modifiedInputs.clear();

        // remove event listeners
        removeEventListener("beforeinput", this.handleBeforeInput);
        removeEventListener("input", this.handleInput as any);
        removeEventListener("submit", this.handleSubmit);
        removeEventListener("beforeunload", this.handleBeforeUnload);
      },

      handleBeforeInput(evt: Event) {
        /** Store default values. */

        const target = evt.target as any;
        if (
          !(this.defaultValue in target || this.defaultValue in target.dataset)
        ) {
          target.dataset[this.defaultValue] = (
            "" + (target.value || target.textContent)
          ).trim();
        }
      },

      handleInput(evt: InputEvent) {
        /** Keep a record of which form inputs have been modified. */
        const target = evt.target as any;

        let original: string;
        if (this.defaultValue in target) {
          original = target[this.defaultValue];
        } else {
          original = target.dataset[this.defaultValue];
        }

        if (original !== ("" + (target.value || target.textContent)).trim()) {
          if (!this.modifiedInputs.has(target)) {
            this.modifiedInputs.add(target);
          }
        } else if (this.modifiedInputs.has(target)) {
          this.modifiedInputs.delete(target);
        }
      },

      // handleSubmit(evt: SubmitEvent) {
      handleSubmit() {
        /** Clear modified inputs before submitting the form. */
        this.modifiedInputs.clear();
      },

      handleBeforeUnload(evt: BeforeUnloadEvent) {
        /** Warn before exiting if any inputs have been modified. */
        if (this.modifiedInputs.size) {
          evt.returnValue = true;
        }
      },
    } as AlpineComponent;

    return {
      ...dataConfirmationRequired,
      ...dataFormModifiedAlertOnExit,

      init() {
        dataConfirmationRequired.init.bind(this)();
        dataFormModifiedAlertOnExit.init.bind(this)();
      },

      destroy() {
        dataFormModifiedAlertOnExit.destroy.bind(this)();
      },
    } as AlpineComponent;
  },
  toastContainer: () => {
    return {
      bindings: {
        "@clear": "$store.toasts.clear",
        "@phx:toast-show.window": "(evt) => $store.toasts.show(evt.detail)",
        "@phx:toast-show-primary.window":
          "(evt) => $store.toasts.showPrimary(evt.detail)",
        "@phx:toast-show-secondary.window":
          "(evt) => $store.toasts.showSecondary(evt.detail)",
        "@phx:toast-show-accent.window":
          "(evt) => $store.toasts.showAccent(evt.detail)",
        "@phx:toast-show-neutral.window":
          "(evt) => $store.toasts.showNeutral(evt.detail)",
        "@phx:toast-show-info.window":
          "(evt) => $store.toasts.showInfo(evt.detail)",
        "@phx:toast-show-success.window":
          "(evt) => $store.toasts.showSuccess(evt.detail)",
        "@phx:toast-show-warning.window":
          "(evt) => $store.toasts.showWarning(evt.detail)",
        "@phx:toast-show-error.window":
          "(evt) => $store.toasts.showError(evt.detail)",
      },

      init() {
        this.$el.setAttribute("x-bind", "bindings");
      },
    } as AlpineComponent;
  },
};

// events
export const events = {
  pushEventHandleFailed() {
    // show error toast message
    (Alpine.store("toasts") as AlpineStore).showError(
      "Error: Could not contact the server"
    );
  },
} as AlpineComponent;

// globals
const globals = { userIsAuthenticated: undefined };

// toasts
type ProjectToastifyOptions = Toastify.Options & {
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
  clear() {
    /** Remove all existing toast messages. */
    document.querySelectorAll(".toastify.on").forEach((toastElt) => {
      toastElt.dispatchEvent(new MouseEvent("click"));
    });
  },
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
      // b. Remap options.content to options.text
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
    const theme = options.theme || "primary";
    switch (theme) {
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

    // only show 3 toasts at a time
    const existingToasts = document.querySelectorAll(".toastify.on");
    if (existingToasts.length > 2) {
      // remove the last toast
      Array.from(existingToasts)
        .slice(-1)[0]
        .dispatchEvent(new MouseEvent("click"));
    }

    // create toast
    toast = Toastify({
      // text: options.content,
      node: textElement,
      className: `toast-${theme}`,
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
    name: "components",
    store: components,
  },
  {
    name: "constants",
    store: constants,
  },
  {
    name: "events",
    store: events,
  },
  {
    name: "globals",
    store: globals,
  },
  {
    name: "helpers",
    store: h,
  },
  {
    name: "toasts",
    store: toasts,
  },
];
