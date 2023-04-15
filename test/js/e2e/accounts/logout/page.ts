import { Locator, Page } from "@playwright/test";
import { BasePage } from "test/e2e/base/page";

import { urls } from "test/support/constants";

export class AccountsLogoutPage extends BasePage {
  readonly page: Page;

  // URLs
  readonly url: URL;
  readonly urlSuccess: URL;

  // page elements
  readonly formButtonCancel: Locator;
  readonly formButtonSubmit: Locator;
  readonly formButtonHome: Locator;
  readonly formButtonLogin: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;

    // URLs
    this.url = new URL(urls.accounts.logout);
    this.urlSuccess = new URL(urls.base.index);

    // form elements
    const logoutForm = page.locator("#logout-form");
    this.formButtonCancel = logoutForm.locator("button", { hasText: "Cancel" });
    this.formButtonSubmit = logoutForm.locator("#logout-form-button-submit");
    this.formButtonHome = logoutForm.locator("button", { hasText: "Home" });
    this.formButtonLogin = logoutForm.locator("button", { hasText: "Login" });
  }

  // actions
  async logout() {
    await this.formButtonSubmit.click(); // submit the form
  }
}
