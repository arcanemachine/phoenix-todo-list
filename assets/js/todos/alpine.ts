import type { AlpineComponent } from "js/alpine";
import h from "js/helpers";

// data
function todosLive() {
  return {
    hook: undefined,

    todoFormInputText: "",
    todoIdSelected: 0,

    init() {
      this.$store.components.todosLive = this; // save component reference in store
    },

    // form
    formInputHandleKeypress(evt: KeyboardEvent) {
      /** Dispatch the proper event to create or update an item. */
      if (evt.key === "Enter") {
        if (this.todoIdSelected !== 0) {
          this.todoUpdateContent();
        } else {
          this.todoCreate();
        }
      }
    },

    formValidate(evt: SubmitEvent) {
      if (this.todoIdSelected !== 0) {
        /* when updating an item, do not submit the form if the value has not changed */
        try {
          const todoContent = this.$root.querySelector(
            `#todo-${this.todoIdSelected}`
          ).dataset.todoContent;

          if (todoContent === this.$refs.formInput.value) {
            evt.stopPropagation();
            evt.preventDefault();

            this.$store.toasts.show({
              content: "You have not made any changes to this item.",
              theme: "warning",
            });
            this.todoSelectedReset();
          }
        } catch (err) {
          evt.stopPropagation();
          evt.preventDefault();

          this.$store.toasts.show({
            content: "Could not update this item",
            theme: "error",
          });
        }
      }
    },

    // event handlers
    handleKeyupEscape() {
      /** Hide the item-delete modal and reset the currently-selected todo item. */
      this.todoDeleteModalHide();
      this.todoSelectedReset();
    },

    // todo delete modal
    todoDeleteModalActive: false,
    todoDeleteModalShow() {
      this.todoDeleteModalActive = true;
    },
    todoDeleteModalHide() {
      this.todoDeleteModalActive = false;
    },

    // todo items (UI)
    todoEltGet(todoId: number) {
      /** Return the component that matches a given todo ID. */
      const todoElt = this.$root.querySelector(`#todo-${todoId}`);

      if (!todoElt)
        this.$store.toasts.showError("The item you requested does not exist.");

      return todoElt;
    },

    todoHandleClick(todoId: number, todoContent: string) {
      /** Toggle a todo's 'currently-selected' status. */
      if (this.todoIdSelected !== todoId) {
        this.todoIdSelected = todoId; // set current todo as 'selected'
        this.todoFormInputText = todoContent; // assign todo content to the form's input field
      } else {
        this.todoSelectedReset();
      }
    },

    todoHandleKeyup(evt: KeyboardEvent) {
      /** When 'delete' key pressed while todo item is active, show the delete item modal. */
      if (this.todoIdSelected === 0) return;
      else if (evt.key === "Delete") this.todoDeleteModalShow();
    },

    todoSelectedReset() {
      /** Reset selected todo and clear the form. */
      this.todoIdSelected = 0;
      this.todoFormInputText = "";
    },

    // todos (CRUD)
    todoCreateSuccess() {
      /** Reset the form and show success message. */
      this.todoSelectedReset();
      this.$store.toasts.showSuccess("Item created successfully");
    },

    todoToggleIsCompletedSuccess() {
      /** Show success message. */
      this.$store.toasts.showSuccess("Item updated successfully");
    },

    todoUpdateContentSuccess(evt: CustomEvent) {
      /** Reset the form, show success message, and highlight the updated element. */
      this.todoSelectedReset(); // reset the form
      this.$store.toasts.showSuccess("Item updated successfully"); // success message

      // highlight updated element
      const todoElt = this.todoEltGet(evt.detail.id);

      this.$store.animations.highlight(
        todoElt.querySelector(".todo-button-content"),
        "success",
        750
      );
    },

    todoDelete() {
      /** Hide the element and push deletion event to the server. */
      const todoIdSelected = this.todoIdSelected; // get reference to current todo ID

      Promise.resolve()
        .then(() => {
          // hide item delete modal and reset selected todo
          this.todoDeleteModalHide();
          this.todoSelectedReset();
        })
        .then(() =>
          // wait for modal to fade out
          h.base.delayFor(this.$store.constants.transitionDurationDefault / 2)
        )
        .then(() => {
          const todoElt = this.todoEltGet(todoIdSelected);

          // disable pointer events and hide todo item element
          todoElt.style.pointerEvents = "none";
          todoElt.dispatchEvent(new CustomEvent("hide"));
        })
        .then(() =>
          // wait for item collapse effect
          h.base.delayFor(this.$store.constants.transitionDurationDefault / 2)
        )
        .then(() => {
          // push delete event to server
          const pushEventResult = this.hook.pushEvent("todo_delete", {
            id: String(todoIdSelected),
          });

          if (pushEventResult === false) {
            /* server push event failed */
            const todoElt = this.todoEltGet(todoIdSelected);

            // re-enable pointer events and show todo item element
            todoElt.style.pointerEvents = "";
            todoElt.dispatchEvent(new CustomEvent("show"));

            // run generic pushEvent failure logic
            this.$store.events.pushEventHandleFailed();
          }
        });
    },

    todoDeleteSuccess() {
      /** Show success message. */
      this.$store.toasts.showSuccess("Item deleted successfully");
    },

    todoDeleteError(evt: CustomEvent) {
      /** Unhide the (attempted) deleted element and show error message. */
      Promise.resolve()
        .then(() => {
          /* unhide the todo item and re-enable pointer events */
          const todoElt = this.todoEltGet(evt.detail.id);

          todoElt.style.pointerEvents = "";
          todoElt.dispatchEvent(new CustomEvent("show"));
        })
        .then(() =>
          h.base.delayFor(this.$store.constants.transitionDurationDefault)
        )
        .then(() => {
          this.$store.toasts.showError("Item could not be deleted"); // error message
        });
    },
  } as AlpineComponent;
}

// exports
export const data = [
  {
    name: "todosLive",
    data: todosLive,
  },
];
