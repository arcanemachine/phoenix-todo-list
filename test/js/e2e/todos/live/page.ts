import { Locator, Page } from "@playwright/test";

import { BasePage } from "test/e2e/base/page";
import { urls } from "test/support/constants";

export class TodosLivePage extends BasePage {
  readonly page: Page;

  // URLs
  readonly url: URL;

  // strings
  readonly stringTodoButtonDeleteLabel: string;
  readonly stringTodoCheckboxIsCompletedLabel: string;
  readonly stringTodoCreateSuccess: string;
  readonly stringTodoUpdateSuccess: string;
  readonly stringTodoDeleteSuccess: string;

  /* page elements */
  readonly alpineComponent: Locator;

  // todo form
  readonly todoForm: Locator;
  readonly todoFormInputText: Locator;
  readonly todoFormButtonSubmit: Locator;

  // todos
  readonly todoList: Locator;

  todoGetByContent(content: string): Locator {
    return this.todoList.getByRole("listitem").filter({ hasText: content });
  }
  //
  todoButtonContent(todo: Locator): Locator {
    return todo.locator("button.todo-button-content");
  }
  todoCheckboxIsCompletedGet(todo: Locator): Locator {
    return todo.getByLabel(this.stringTodoCheckboxIsCompletedLabel);
  }
  todoButtonDeleteGet(todo: Locator): Locator {
    return todo.getByLabel(this.stringTodoButtonDeleteLabel);
  }

  // todo delete modal
  readonly todoDeleteModal: Locator;
  readonly todoDeleteModalButtonConfirm: Locator;
  readonly todoDeleteModalButtonCancel: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;

    // URLs
    this.url = new URL(urls.todos.todosLive);

    // strings
    this.stringTodoButtonDeleteLabel = "Delete item";
    this.stringTodoCheckboxIsCompletedLabel = "Toggle completion status";
    this.stringTodoCreateSuccess = "Item created successfully";
    this.stringTodoUpdateSuccess = "Item updated successfully";
    this.stringTodoDeleteSuccess = "Item deleted successfully";

    /* page elements */
    this.alpineComponent = page.locator("#todos-live");

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

  /* actions */
  // CRUD
  async todoCreate(content: string) {
    // fill out the form
    await this.todoFormInputText.click();
    await this.todoFormInputText.fill(content);

    // submit the form
    await this.todoFormButtonSubmit.click();
  }

  async todoUpdateContent(content: string) {
    // fill out the form
    await this.todoFormInputText.click();
    await this.todoFormInputText.fill(content);

    // submit the form
    await this.todoFormButtonSubmit.click();
  }

  // misc
  async todoIdGet(todo: Locator): Promise<Number> {
    /** Return the ID of a given todo item. */
    return Number(await todo.getAttribute("data-todo-id"));
  }

  async todoIdSelectedGet(): Promise<Number> {
    /**
     * Return the ID of the currently-selected todo item.
     * If no todo item is currently selected, this function will return 0;
     */
    return Number(
      await this.alpineComponent.getAttribute("data-todo-id-selected")
    );
  }
}
