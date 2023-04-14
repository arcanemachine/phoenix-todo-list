import { Locator, Page } from "@playwright/test";

import { urls } from "test/support/constants";

export class AccountsLoginPage {
  readonly page: Page;

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
    this.page = page;

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

  async goto() {
    await this.page.goto(this.url.toString());
  }

  async login(email: string, password: string, options = { submit: true }) {
    // fill out the form
    await this.inputEmail.click();
    await this.inputEmail.type(email);

    await this.inputPassword.click();
    await this.inputPassword.type(password);

    if (options.submit) {
      // submit the form
      await this.formButtonSubmit.click();
    }
  }
}