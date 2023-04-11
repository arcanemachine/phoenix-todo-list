import { Locator, Page } from "@playwright/test";

import { urls } from "test/support/constants";
import { urlBuild } from "test/support/helpers";

export class BaseIndexPage {
  readonly page: Page;
  readonly title: Locator;

  constructor(page: Page) {
    this.page = page;
    this.title = page.locator("#page-title"); // page elements
  }

  async goto() {
    await this.page.goto(urlBuild(urls.base.index));
  }
}
