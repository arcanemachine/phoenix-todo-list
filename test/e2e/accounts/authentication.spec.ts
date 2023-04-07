import { test, expect } from "@playwright/test";

test.describe.only("Registration workflow", () => {
  test("contains expected title", async ({ baseURL, page }) => {
    await page.goto((baseURL as string) + "/users/register");
    await expect(page).toHaveTitle(/Register/);
  });

  // test("registers a new user")
});
