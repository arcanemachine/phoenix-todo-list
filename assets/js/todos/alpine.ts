import { delayFor } from "../base/helpers";

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
            `#todo-item-${this.todoIdSelected}`
          ).dataset.todoContent;

          if (todoContent === this.$refs.formInput.value) {
            evt.stopPropagation();
            evt.preventDefault();

            this.$store.toasts.show({
              content: "You have not made any changes to this item.",
              theme: "warning",
            });
            this.todoItemSelectedReset();
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
      this.todoItemSelectedReset();
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
    todoItemEltGet(todoId: number) {
      /** Return the component that matches a given todo ID. */
      const todoItemElt = this.$root.querySelector(`#todo-item-${todoId}`);

      if (!todoItemElt)
        this.$store.toasts.showError("The item you requested does not exist.");

      return todoItemElt;
    },

    todoItemHandleClick(todoId: number, todoContent: string) {
      /** Toggle a todo's 'currently-selected' status. */
      if (this.todoIdSelected !== todoId) {
        this.todoIdSelected = todoId; // set current todo as 'selected'
        this.todoFormInputText = todoContent; // assign todo content to the form's input field
      } else {
        this.todoItemSelectedReset();
      }
    },

    todoItemHandleKeyup(evt: KeyboardEvent) {
      /** When 'delete' key pressed while todo item is active, show the delete item modal. */
      if (this.todoIdSelected === 0) return;
      else if (evt.key === "Delete") this.todoDeleteModalShow();
    },

    todoItemSelectedReset() {
      /** Reset selected todo and clear the form. */
      this.todoIdSelected = 0;
      this.todoFormInputText = "";
    },

    // todos (CRUD)
    todoCreateSuccess() {
      /** Reset the form and show success message. */
      this.todoItemSelectedReset();
      this.$store.toasts.showSuccess("Item created successfully");
    },

    todoToggleIsCompletedSuccess() {
      /** Show success message. */
      this.$store.toasts.showSuccess("Item updated successfully");
    },

    todoUpdateContentSuccess(evt: CustomEvent) {
      /** Reset the form, show success message, and highlight the updated element. */
      this.todoItemSelectedReset(); // reset the form
      this.$store.toasts.showSuccess("Item updated successfully"); // success message

      // highlight updated element
      const todoItemElt = this.todoItemEltGet(evt.detail.todo_id);

      this.$store.animations.highlight(
        todoItemElt.querySelector(".todo-item-content-container"),
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
          this.todoItemSelectedReset();
        })
        .then(() =>
          delayFor(this.$store.constants.collapseTransitionDuration / 2)
        )
        .then(() => {
          /* disable pointer events and hide todo item element */
          const todoItemElt = this.todoItemEltGet(todoIdSelected);

          todoItemElt.style.pointerEvents = "none";
          todoItemElt.dispatchEvent(new CustomEvent("hide"));
        })
        .then(() =>
          delayFor(this.$store.constants.collapseTransitionDuration / 2)
        )
        .then(() => {
          this.hook.pushEvent("todo_delete", { todo_id: todoIdSelected });
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
          const todoItemElt = this.todoItemEltGet(evt.detail.todo_id);

          todoItemElt.style.pointerEvents = "";
          todoItemElt.dispatchEvent(new CustomEvent("show"));
        })
        .then(() => delayFor(this.$store.constants.collapseTransitionDuration))
        .then(() => {
          this.$store.toasts.showError("Item could not be deleted"); // error message
        });
    },
  };
}

// exports
export const data = [
  {
    name: "todosLive",
    data: todosLive,
  },
];
