import { Locator, Page } from "@playwright/test";

import { urls } from "test/support/constants";

export class AccountsLogoutPage {
  readonly page: Page;

  // URLs
  readonly url: URL;
  readonly urlSuccess: URL;

  // form elements
  readonly formButtonCancel: Locator;
  readonly formButtonSubmit: Locator;
  readonly formButtonHome: Locator;
  readonly formButtonLogin: Locator;

  constructor(page: Page) {
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

  async goto() {
    await this.page.goto(this.url.toString());
  }

  async logout() {
    await this.formButtonSubmit.click(); // submit the form
  }
}
