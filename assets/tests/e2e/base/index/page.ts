import { Page } from "@playwright/test";

import { urls } from "tests/support/constants";
import { BasePage } from "tests/e2e/base/page";

export class BaseIndexPage extends BasePage {
  readonly page: Page;
  readonly url: URL;

  constructor(page: Page) {
    super(page);
    this.page = page;

    this.url = urls.base.index;
  }
}
