import { expect } from "@playwright/test";

import { authenticatedTest, genericTests } from "test/e2e/support/fixtures";
import { TodosLivePage } from "./page";

// generic tests
genericTests.redirectsUnauthenticatedUserToLoginPage(
  "Todos live page",
  TodosLivePage
);

// custom tests
authenticatedTest.describe.only("[Authenticated] Todos live page", async () => {
  let todosLivePage: TodosLivePage;

  authenticatedTest.beforeEach(async ({ page }) => {
    // navigate to test page
    todosLivePage = new TodosLivePage(page);
    await todosLivePage.goto();
  });

  authenticatedTest("contains expected title", async () => {
    await expect(todosLivePage.title).toHaveText("Live Todo List");
  });
});
