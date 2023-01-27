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

    // todo items
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
  };
}
