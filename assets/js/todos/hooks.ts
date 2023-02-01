import Alpine from "alpinejs";

const Hooks = {
  TodosLive: {
    // data
    get component() {
      return Alpine.store("components").todosLive;
    },

    // lifecycle
    mounted() {
      this.component.hook = this;
    },
  },
};

export default Hooks;
