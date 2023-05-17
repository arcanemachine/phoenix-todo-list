import Alpine from "alpinejs";

import { AlpineStore } from "../alpine";

const Hooks = {
  TodosLive: {
    // data
    get component() {
      const alpineStoreComponents = Alpine.store("components") as AlpineStore;
      return alpineStoreComponents.todosLive;
    },

    // lifecycle
    mounted() {
      this.component.hook = this;
    },
  },
};

export default Hooks;
