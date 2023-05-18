import Alpine from "alpinejs";

import { AlpineStore } from "../alpine";

const Hooks = {
  TodosLive: {
    // data
    get component() {
      const alpineStoreComponents: AlpineStore = Alpine.store("components");
      return alpineStoreComponents.todosLive;
    },

    // lifecycle
    mounted() {
      this.component.hook = this;
    },
  },
};

export default Hooks;
