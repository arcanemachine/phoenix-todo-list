import { Locator, Page } from "@playwright/test";

import { urls } from "test/support/constants";
import { urlBuild } from "test/support/helpers";

export class AccountsRegisterPage {
  readonly page: Page;

  // URLs
  readonly url: string;
  readonly urlSuccess: string;

  // form elements
  readonly formButtonSubmit: Locator;
  readonly inputEmail: Locator;
  readonly inputPassword: Locator;
  readonly inputPasswordConfirmation: Locator;

  constructor(page: Page) {
    this.page = page;

    // URLs
    this.url = urlBuild(urls.accounts.register);
    this.urlSuccess = urlBuild(urls.todos.todosLive);

    // form elements
    this.inputEmail = page.locator("input[name='user[email]']");
    this.inputPassword = page.locator("input[name='user[password]']");
    this.inputPasswordConfirmation = page.locator(
      "input[name='user[password_confirmation]']"
    );
    this.formButtonSubmit = page
      .locator("#registration_form")
      .locator("button[type='submit']");
  }

  async goto() {
    await this.page.goto(this.url);
  }

  // actions
  async register(email: string, password: string) {
    // fill out the form
    await this.inputEmail.click();
    await this.inputEmail.type(email);

    await this.inputPassword.click();
    await this.inputPassword.type(password);

    await this.inputPasswordConfirmation.click();
    await this.inputPasswordConfirmation.type(password);

    // submit the form
    await this.formButtonSubmit.click();
  }
}
