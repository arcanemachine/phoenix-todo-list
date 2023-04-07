import { test, expect } from "@playwright/test";

test.describe("Page", () => {
  test("contains expected title", async ({ page }) => {
    await page.goto("http://localhost:4002/");
    await expect(page).toHaveTitle(/Home/);
  });
});
