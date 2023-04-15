import { Locator, Page } from "@playwright/test";

import { BasePage } from "test/e2e/base/page";
import { urls } from "test/support/constants";

export class TodosLivePage extends BasePage {
  readonly page: Page;

  // URLs
  readonly url: URL;

  // strings
  readonly stringTodoCreateSuccess: string;

  /* page elements */
  readonly title: Locator;

  // todo form
  readonly todoForm: Locator;
  readonly todoFormInputText: Locator;
  readonly todoFormButtonSubmit: Locator;

  // todos
  readonly todoList: Locator;

  async todoGetById(id: number): Promise<Locator> {
    /** Return the Locator that contains a given todo item's elements. */
    return this.todoList.locator(`li#todo-item-${id}`);
  }
  async todoGetByContent(content: string): Promise<Locator> {
    /** Return the Locator that contains a given todo item's elements. */
    return this.todoList.locator(`[data-todo-id]`, { hasText: content });
  }

  async todoButtonContent(todo: Locator): Promise<Locator> {
    return todo.locator("button.todo-button-content");
  }
  async todoCheckboxIsCompletedGet(todo: Locator): Promise<Locator> {
    return todo.locator(`button.todo-is-completed-checkbox`);
  }
  async todoButtonDeleteGet(todo: Locator): Promise<Locator> {
    return todo.locator("button.todo-button-delete");
  }

  // todo delete modal
  readonly todoDeleteModal: Locator;
  readonly todoDeleteModalButtonConfirm: Locator;
  readonly todoDeleteModalButtonCancel: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;

    // strings
    this.stringTodoCreateSuccess = "Item created successfully";

    // URLs
    this.url = new URL(urls.todos.todosLive);

    /* page elements */
    this.title = page.locator("#page-title");

    // todo form
    this.todoForm = page.locator("#todo-form");
    this.todoFormInputText = this.todoForm.locator("input[type='text']");
    this.todoFormButtonSubmit = this.todoForm.locator("button");

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
  async todoCreate(content: string) {
    await this.todoFormInputText.click();
    await this.todoFormInputText.type(content);
    await this.todoFormButtonSubmit.click();
  }
}
