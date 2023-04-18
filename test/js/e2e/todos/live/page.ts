import { Locator, Page } from "@playwright/test";

import { BasePage } from "test/e2e/base/page";
import { urls } from "test/support/constants";

export class TodosLivePage extends BasePage {
  readonly page: Page;

  // URLs
  readonly url: URL;

  // strings
  readonly stringTodoCreateSuccess: string;
  readonly stringTodoUpdateSuccess: string;
  readonly stringTodoCheckboxIsCompletedLabel: string;

  /* page elements */
  readonly pageTitle: Locator;
  readonly alpineComponent: Locator;

  // todo form
  readonly todoForm: Locator;
  readonly todoFormInputText: Locator;
  readonly todoFormButtonSubmit: Locator;

  // todos
  readonly todoList: Locator;

  // async todoGetById(id: number): Promise<Locator> {
  //   /** Return the Locator that contains a given todo item's elements. */
  //   return this.todoList.locator(`li#todo-item-${id}`);
  // }

  // todoGetByContent(content: string): Locator {
  //   /** Return the Locator that contains a given todo item's elements. */
  //   return this.todoList.locator("[data-todo-id]", { hasText: content });
  // }
  todoGetByContent(content: string): Locator {
    /** Return the Locator that contains a given todo item's elements. */
    return this.todoList.getByRole("listitem").filter({ hasText: content });
  }
  //
  todoButtonContent(todo: Locator): Locator {
    return todo.locator("button.todo-button-content");
  }
  // todoCheckboxIsCompletedGet(todo: Locator): Locator {
  //   return todo.locator(`button.todo-checkbox-is-completed`);
  // }
  todoCheckboxIsCompletedGet(todo: Locator): Locator {
    return todo.getByLabel(this.stringTodoCheckboxIsCompletedLabel);
  }
  // todoDeleteButtonGet(todo: Locator): Locator {
  //   return todo.locator("button.todo-delete-button");
  // }

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
    this.stringTodoCreateSuccess = "Item created successfully";
    this.stringTodoUpdateSuccess = "Item updated successfully";
    this.stringTodoCheckboxIsCompletedLabel = "Toggle completion status";

    /* page elements */
    this.pageTitle = page.locator("#page-title");
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

  async todoUpdateContent(todo: Locator, content: string) {
    // select the todo item
    await this.todoSelect(todo);

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

  async todoSelect(todo: Locator) {
    /**
     * Ensure that a given todo is selected by clicking it.
     * TODO: If another todo is selected, un-select that todo and select
     *       the desired one. If the desired Todo is already selected, this
     *       function will not do anything.
     */
    // click the todo to select it
    const todoButtonContent = this.todoButtonContent(todo);
    await todoButtonContent.click();
  }
}
