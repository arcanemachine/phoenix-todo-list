import { Locator, Page } from "@playwright/test";
import { urls } from "test/support/constants";

export class TodosLivePage {
  readonly page: Page;

  readonly url: URL; // URLs

  readonly title: Locator; // page elements

  constructor(page: Page) {
    this.page = page;
    this.url = new URL(urls.todos.todosLive); // URLs
    this.title = page.locator("#page-title"); // page elements
  }

  // actions
  async goto() {
    await this.page.goto(this.url.toString());
  }
}
