import Alpine from "alpinejs";

const Hooks = {
  TodosLive: {
    mounted() {
      Alpine.store("components").todosLive.hook = this;
    },
  },
};

export default Hooks;
