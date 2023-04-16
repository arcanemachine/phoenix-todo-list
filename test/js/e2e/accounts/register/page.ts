import { Locator, Page } from "@playwright/test";

import { BasePage } from "test/e2e/base/page";
import { urls } from "test/support/constants";

export class AccountsRegisterPage extends BasePage {
  readonly page: Page;

  // URLs
  readonly url: URL;
  readonly urlSuccess: URL;

  // page elements
  readonly inputEmail: Locator;
  readonly inputErrorEmail: Locator;

  readonly inputPassword: Locator;
  readonly inputErrorPassword: Locator;

  readonly inputPasswordConfirmation: Locator;
  readonly inputErrorPasswordConfirmation: Locator;

  readonly formButtonSubmit: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;

    // URLs
    this.url = new URL(urls.accounts.register);
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

    this.inputPasswordConfirmation = page.locator(
      "input[name='user[password_confirmation]']"
    );
    this.inputErrorPasswordConfirmation = page.locator(
      "[phx-feedback-for='user[password_confirmation]'] [data-component='error']"
    );

    this.formButtonSubmit = page
      .locator("#registration_form")
      .locator("button[type='submit']");
  }

  // actions
  async register(
    email: string,
    password: string,
    options?: {
      passwordConfirmation?: string;
      submit?: boolean;
    }
  ) {
    const defaultOptions = {
      passwordConfirmation: undefined,
      submit: true,
    };

    // merge options with default options
    options = {
      ...defaultOptions,
      ...options,
    };

    // if no password confirmation value specified, copy the value from the password
    const passwordConfirmation = options.passwordConfirmation ?? password;

    // fill out the form
    await this.inputEmail.click();
    await this.inputEmail.fill(email);

    await this.inputPassword.click();
    await this.inputPassword.fill(password);

    await this.inputPasswordConfirmation.click();
    await this.inputPasswordConfirmation.fill(passwordConfirmation);

    if (options.submit) {
      // submit the form
      await this.formButtonSubmit.click();
    }
  }
}
