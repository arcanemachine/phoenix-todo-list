import { Locator, Page } from "@playwright/test";

import { urls } from "test/support/constants";
import { urlBuild } from "test/support/helpers";

export class AccountsRegisterPage {
  readonly page: Page;

  // URLs
  readonly url: string;
  readonly urlSuccess: string;

  // form elements
  readonly inputEmail: Locator;
  readonly errorEmail: Locator;

  readonly inputPassword: Locator;
  readonly errorPassword: Locator;

  readonly inputPasswordConfirmation: Locator;
  readonly errorPasswordConfirmation: Locator;

  readonly formButtonSubmit: Locator;

  constructor(page: Page) {
    this.page = page;

    // URLs
    this.url = urlBuild(urls.accounts.register);
    this.urlSuccess = urlBuild(urls.todos.todosLive);

    /* form elements */
    // email
    this.inputEmail = page.locator("input[name='user[email]']");
    this.errorEmail = page.locator(
      "[phx-feedback-for='user[email]'] [data-component='error']"
    );

    // password
    this.inputPassword = page.locator("input[name='user[password]']");
    this.errorPassword = page.locator(
      "[phx-feedback-for='user[password]'] [data-component='error']"
    );

    // password confirmation
    this.inputPasswordConfirmation = page.locator(
      "input[name='user[password_confirmation]']"
    );
    this.errorPasswordConfirmation = page.locator(
      "[phx-feedback-for='user[password_confirmation]'] [data-component='error']"
    );

    // submit button
    this.formButtonSubmit = page
      .locator("#registration_form")
      .locator("button[type='submit']");
  }

  async goto() {
    await this.page.goto(this.url);
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

    const passwordConfirmation = options.passwordConfirmation || password;

    // fill out the form
    await this.inputEmail.click();
    await this.inputEmail.type(email);

    await this.inputPassword.click();
    await this.inputPassword.type(password);

    await this.inputPasswordConfirmation.click();
    await this.inputPasswordConfirmation.type(passwordConfirmation);

    if (options.submit) {
      // submit the form
      await this.formButtonSubmit.click();
    }
  }
}
