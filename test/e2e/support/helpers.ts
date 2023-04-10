import { Page, expect } from "@playwright/test";
import { randomUUID } from "crypto";
import config from "test/playwright.config";

import { urls } from "test/constants";

const baseURL = config.use!.baseURL;

export function generateRandomEmail() {
  return `${randomUUID()}@example.com`;
}

type UrlHelperOptions = {
  navigateToUrl?: boolean;
  login?: boolean;
};

export async function userRegister(
  page: Page,
  email: string,
  password: string,
  options: UrlHelperOptions = {
    navigateToUrl: false,
    login: true,
  }
) {
  if (options.navigateToUrl) await page.goto(baseURL + urls.users.register);

  // fill out the form
  // await page.locator("input[name='user[email]']").click();
  await page.locator("input[name='user[email]']").type(email);

  // await page.locator("input[name='user[password]']").click();
  await page.locator("input[name='user[password]']").type(password);

  // await page.locator("input[name='user[password_confirmation]']").click();
  await page
    .locator("input[name='user[password_confirmation]']")
    .type(password);

  // submit the form
  await page
    .locator("#registration_form")
    .locator("button[type='submit']")
    .click();

  await page.waitForResponse(() => true);

  if (!options.login) {
    await userLogout(page, { navigateToUrl: true });
  }
}

export async function userLogin(
  page: Page,
  email: string,
  password: string,
  options = {
    navigateToUrl: false,
  }
) {
  if (options.navigateToUrl) await page.goto(baseURL + urls.users.login);

  // fill out the form
  // await page.locator("input[name='user[email]']").click();
  await page.locator("input[name='user[email]']").type(email);

  //await page.locator("input[name='user[password]']").click();
  await page.locator("input[name='user[password]']").type(password);

  // submit the form
  await page.locator("#login_form").locator("button[type='submit']").click();
}

export async function userLogout(
  page: Page,
  options = {
    navigateToUrl: false,
  }
) {
  if (options.navigateToUrl) await page.goto(baseURL + urls.users.logout);

  // click the 'confirm' button
  await page.locator("#logout-form-button-submit").click();
}
