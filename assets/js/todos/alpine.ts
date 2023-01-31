import { delayFor } from "../base/helpers";

// data
function todosLive() {
  return {
    todoFormInputText: "",
    todoIdSelected: 0,

    // form
    formInputHandleKeypress(evt: KeyboardEvent) {
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

    // todo delete modal
    todoDeleteModalActive: false,
    todoDeleteModalShow() {
      this.todoDeleteModalActive = true;
    },
    todoDeleteModalHide(todoId?: number) {
      if (todoId && todoId !== this.todoIdSelected) return;

      this.$nextTick().then(() => {
        this.todoDeleteModalActive = false;
        this.todoItemSelectedReset();
      });
    },

    // todo items (UI)
    todoItemHandleClick(todoId: number, todoContent: string) {
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
      // reset selected todo and clear form
      this.todoIdSelected = 0;
      this.todoFormInputText = "";
    },

    // todos (CRUD)
    todoCreateSuccess() {
      this.todoItemSelectedReset(); // reset the form
      this.$store.toasts.showSuccess("Item created successfully"); // success message
    },

    todoUpdateContentSuccess(evt: CustomEvent) {
      this.todoItemSelectedReset(); // reset the form
      this.$store.toasts.showSuccess("Item updated successfully"); // success message

      // highlight updated element
      const todoItemContentElt = this.$root
        .querySelector(`#todo-item-${evt.detail.todo_id}`)
        .querySelector(".todo-item-content");

      this.$store.animations.highlight(
        todoItemContentElt.closest("button"),
        "success",
        750
      );
    },

    todoDeleteSuccess() {
      this.todoDeleteModalHide(); // hide delete modal
      this.$store.toasts.showSuccess("Item deleted successfully"); // success message
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
