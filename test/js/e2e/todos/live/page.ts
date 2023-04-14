import { Locator, Page } from "@playwright/test";
import { urls } from "test/support/constants";

export class TodosLivePage {
  readonly page: Page;

  readonly url: URL; // URLs

  /* page elements */
  readonly title: Locator;

  // todo form
  readonly todoForm: Locator;
  readonly todoFormInputText: Locator;
  readonly todoFormButtonSubmit: Locator;

  // todos
  readonly todoList: Locator;
  async todoGet(id: number): Promise<Locator> {
    /** Return the Locator that contains a given todo item's elements. */
    return this.todoList.locator(`li#todo-item-${id}`);
  }
  async todoButtonContentGet(id: number): Promise<Locator> {
    const todo = await this.todoGet(id);
    return todo.locator("button.todo-button-content");
  }
  async todoCheckboxIsCompletedGet(id: number): Promise<Locator> {
    const todo = await this.todoGet(id);
    return todo.locator(`button.todo-is-completed-checkbox`);
  }
  async todoButtonDeleteGet(id: number): Promise<Locator> {
    const todo = await this.todoGet(id);
    return todo.locator("button.todo-button-delete");
  }

  // todo delete modal
  readonly todoDeleteModal: Locator;
  readonly todoDeleteModalButtonConfirm: Locator;
  readonly todoDeleteModalButtonCancel: Locator;

  constructor(page: Page) {
    this.page = page;

    this.url = new URL(urls.todos.todosLive); // URLs

    /* page elements */
    this.title = page.locator("#page-title");

    // todo form
    this.todoForm = page.locator("#todo-form");
    this.todoFormInputText = this.todoForm.locator("input[type='text']");
    this.todoFormButtonSubmit = this.todoForm.locator("button[type='text']");

    // todos
    this.todoList = page.locator("#todo-list");

    // todo delete modal
    this.todoDeleteModal = page.locator("#todo-delete-modal");
    this.todoDeleteModalButtonConfirm = this.todoDeleteModal.locator("button", {
      hasText: "Yes",
    });
    this.todoDeleteModalButtonCancel = this.todoDeleteModal.locator("button", {
      hasText: "No",
    });
  }

  // actions
  async goto() {
    await this.page.goto(this.url.toString());
  }
}
