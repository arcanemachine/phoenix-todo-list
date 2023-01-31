import { delayFor } from "../base/helpers";

// data
function todosLive() {
  return {
    hook: undefined,

    todoFormInputText: "",
    todoIdSelected: 0,

    init() {
      this.$store.components.todosLive = this;
    },

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

      // this.$nextTick().then(() => {
      this.todoDeleteModalActive = false;
      this.todoItemSelectedReset();
      // });
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

    todoDelete() {
      /** Hide the element and push deleted event to the server. */
      const todoIdSelected = this.todoIdSelected; // get reference to current todo ID

      Promise.resolve()
        .then(() => {
          this.todoDeleteModalHide(); // hide todo-delete modal
        })
        .then(() =>
          delayFor(this.$store.constants.collapseTransitionDuration / 2)
        )
        .then(() => {
          // disable pointer events and hide todo item element
          const todoItemElt = this.$root.querySelector(
            `#todo-item-${todoIdSelected}`
          );

          todoItemElt.style.pointerEvents = "none";
          todoItemElt.dispatchEvent(new CustomEvent("hide"));
        })
        .then(() => delayFor(this.$store.constants.collapseTransitionDuration))
        .then(() => {
          this.hook.pushEvent("todo_delete", { todo_id: todoIdSelected });
        });
    },

    todoDeleteError(evt: CustomEvent) {
      /** Unhide the (attempted) deleted element and show error message. */
      Promise.resolve()
        .then(() => {
          // enable pointer events and show todo item element
          const todoItemElt = this.$root.querySelector(
            `#todo-item-${evt.detail.todo_id}`
          );

          todoItemElt.style.pointerEvents = "";
          todoItemElt.dispatchEvent(new CustomEvent("show")); // hide the todo
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
