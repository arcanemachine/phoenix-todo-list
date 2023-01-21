import tippy from "tippy.js";
import "tippy.js/dist/tippy.css";

import projectHelpers from "../helpers";

const directives = [
  {
    name: "tooltip",
    directive(elt: HTMLElement, { expression }, { evaluate, cleanup }) {
      const defaultOptions = {
        delay: [750, null],
        hideOnClick: true,
        // interactiveDebounce: 150,
        touch: "hold",
      };

      // parse expression and convert to object
      let options: Record<string, any>;
      if (projectHelpers.alpineExpressionIsObject(expression)) {
        options = evaluate(expression); // expression is an object
      } else {
        options = { content: expression }; // convert expression to object
      }

      // final options
      options = {
        ...defaultOptions,
        ...options,
      };

      const tip = tippy(elt, options); // create tooltip

      // when element is removed from the DOM, destroy the tooltip
      cleanup(() => {
        tip.destroy();
      });
    },
  },
];

export default directives;
