import { Locator, Page } from "@playwright/test";

import { BasePage } from "tests/e2e/base/page";
import { urls } from "tests/support/constants";

export class AccountsLoginPage extends BasePage {
  readonly page: Page;
  readonly phxConnected: Locator;

  // URLs
  readonly url: URL;
  readonly urlSuccess: URL;

  // page elements
  readonly inputEmail: Locator;
  readonly inputErrorEmail: Locator;

  readonly inputPassword: Locator;
  readonly inputErrorPassword: Locator;

  readonly formButtonSubmit: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;
    this.phxConnected = this.page.locator("[data-phx-main].phx-connected");

    // URLs
    this.url = new URL(urls.accounts.login);
    this.urlSuccess = new URL(urls.todos.todosLive);

    // form elements
    this.inputEmail = page.locator("input[name='user[email]']");
    this.inputErrorEmail = page.locator(
      "[phx-feedback-for='user[email]'] [data-component='error']"
    );

    this.inputPassword = page.locator("input[name='user[password]']");
    this.inputErrorPassword = page.locator(
      "[phx-feedback-for='user[password]'] [data-component='error']"
    );

    this.formButtonSubmit = page
      .locator("#login_form")
      .locator("button[type='submit']");
  }

  async login(email: string, password: string, options = { submit: true }) {
    // fill out the form
    await this.inputEmail.click();
    await this.inputEmail.fill(email);

    await this.inputPassword.click();
    await this.inputPassword.fill(password);

    if (options.submit) {
      // submit the form
      await this.formButtonSubmit.click();
    }
  }
}
