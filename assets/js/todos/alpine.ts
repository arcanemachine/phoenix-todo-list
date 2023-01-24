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
    deleteModalHide() {
      this.$nextTick().then(() => {
        this.deleteModalActive = false;
        this.todoIdSelected = 0;
      });
    },

    afterPhxLoading(eventType: string, callback: Function) {
      /** When loading event has ended, execute a callback. */
      this.$nextTick().then(() => {
        const timer = setInterval(() => {
          if (this.$el.classList.contains(`phx-${eventType}-loading`)) {
            return;
          } else {
            clearInterval(timer);
            callback.bind(this)();
          }
        }, 100);
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

    todoItemSelectedReset() {
      // reset selected todo and clear form
      this.todoIdSelected = 0;
      this.todoFormInputText = "";
    },
  };
}
