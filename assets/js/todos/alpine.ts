/* data */
export const data = [
  {
    name: "todosLive",
    data: todosLive,
  },
];

// data - functions
function todosLive() {
  return {
    todoFormInputText: "",
    todoIdSelected: 0,

    // delete modal
    deleteModalActive: false,
    deleteModalShow() {
      this.deleteModalActive = true;
    },
    deleteModalHide(todoId?: number) {
      // when server pushes delete event result, close the delete item modal if the todo ID
      // matches the currently selected todo ID. this prevents the modal from being closed if
      // the item delete modal is open for a different todo
      if (todoId && todoId !== this.todoIdSelected) return;

      this.$nextTick().then(() => {
        this.deleteModalActive = false;
        this.todoIdSelected = 0;
      });
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
        // when updating an item, do not submit the form if the value has not changed
        const todoContent = this.todoItemEltGet(this.todoIdSelected).dataset
          .todoContent;

        if (todoContent === this.$refs.formInput.value) {
          alert("The content of this item has not changed.");
          return false;
          evt.stopPropagation();
          evt.preventDefault();
        }
      }
    },

    // todo items (UI)
    todoItemEltGet(todoId: number, customSelectors = "") {
      /** Return an element based on its todo ID. Accepts custom selectors. */
      return this.$root.querySelector(
        `#todo-item-${todoId} ${customSelectors}`
      );
    },

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
      else if (evt.key === "Delete") this.deleteModalShow();
    },

    todoItemSelectedReset() {
      // reset selected todo and clear form
      this.todoIdSelected = 0;
      this.todoFormInputText = "";
    },

    // todos (CRUD)
    todoUpdateContentSuccess(evt: CustomEvent) {
      // get todo item element
      const todoItemContentElt = this.todoItemEltGet(
        evt.detail.todo_id,
        ".todo-item-content"
      );

      // update todo item content
      todoItemContentElt.innerText = evt.detail.todo_content;

      // apply 'update' animation
      this.$store.animations.highlight(
        todoItemContentElt.closest("li"),
        "success"
      );

      // reset the form
      this.todoItemSelectedReset();
    },
  };
}
