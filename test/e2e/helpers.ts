import { Page } from "@playwright/test";
import { randomUUID } from "crypto";

export async function userLogin(page: Page, email: string, password: string) {
  //// fill out the form
  // await page.locator("input[name='user[email]']").click();
  await page.locator("input[name='user[email]']").fill(email);

  //await page.locator("input[name='user[password]']").click();
  await page.locator("input[name='user[password]']").fill(password);

  // submit the form
  await page.locator("#login_form").locator("button[type='submit']").click();
}

export async function userRegister(
  page: Page,
  email: string,
  password: string
) {
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
}

export function generateRandomEmail() {
  return `${randomUUID()}@example.com`;
}
