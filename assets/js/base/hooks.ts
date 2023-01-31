import Alpine from "alpinejs";

const Hooks = {
  ToastHook: {
    mounted() {
      window.addEventListener(
        "phx:toast-show.window",
        Alpine.store("toasts").show
      );
      window.addEventListener(
        "phx:toast-show-primary",
        Alpine.store("toasts").showPrimary
      );
      window.addEventListener(
        "phx:toast-show-secondary",
        Alpine.store("toasts").showSecondary
      );
      window.addEventListener(
        "phx:toast-show-accent",
        Alpine.store("toasts").showAccent
      );
      window.addEventListener(
        "phx:toast-show-neutral",
        Alpine.store("toasts").showNeutral
      );
      window.addEventListener(
        "phx:toast-show-info",
        Alpine.store("toasts").showInfo
      );
      window.addEventListener(
        "phx:toast-show-success",
        Alpine.store("toasts").showSuccess
      );
      window.addEventListener(
        "phx:toast-show-warning",
        Alpine.store("toasts").showWarning
      );
      window.addEventListener(
        "phx:toast-show-error",
        Alpine.store("toasts").showError
      );
    },
    destroyed() {
      window.removeEventListener(
        "phx:toast-show.window",
        Alpine.store("toasts").show
      );
      window.removeEventListener(
        "phx:toast-show-primary",
        Alpine.store("toasts").showPrimary
      );
      window.removeEventListener(
        "phx:toast-show-secondary",
        Alpine.store("toasts").showSecondary
      );
      window.removeEventListener(
        "phx:toast-show-accent",
        Alpine.store("toasts").showAccent
      );
      window.removeEventListener(
        "phx:toast-show-neutral",
        Alpine.store("toasts").showNeutral
      );
      window.removeEventListener(
        "phx:toast-show-info",
        Alpine.store("toasts").showInfo
      );
      window.removeEventListener(
        "phx:toast-show-success",
        Alpine.store("toasts").showSuccess
      );
      window.removeEventListener(
        "phx:toast-show-warning",
        Alpine.store("toasts").showWarning
      );
      window.removeEventListener(
        "phx:toast-show-error",
        Alpine.store("toasts").showError
      );
    },
  },
};

export default Hooks;
