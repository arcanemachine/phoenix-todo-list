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
    todos: [],
    todoFormInputText: "",
    todoIdSelected: 0,

    something: {
      hello: "world",
      goodbye: "troubles",
    },

    // delete
    deleteModalActive: false,
    deleteModalShow() {
      console.log("deleteModalShow()");
      this.deleteModalActive = true;
    },
    deleteModalHide() {
      console.log("deleteModalHide()");
      this.deleteModalActive = false;
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
        // reset selected todo and clear form
        this.todoIdSelected = 0;
        this.todoFormInputText = "";
      }
    },
  };
}
