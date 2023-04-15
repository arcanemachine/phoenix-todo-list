import { Locator, Page } from "@playwright/test";

import { urls } from "test/support/constants";
import { BasePage } from "test/e2e/base/page";

export class BaseIndexPage extends BasePage {
  readonly page: Page;
  readonly title: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;

    this.title = page.locator("#page-title"); // page elements
  }

  // actions
  async goto() {
    await this.page.goto(urls.base.index.toString());
  }
}
