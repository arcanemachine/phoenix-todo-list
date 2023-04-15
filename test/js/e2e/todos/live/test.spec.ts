import { expect } from "@playwright/test";
import { randomUUID } from "crypto";

import { authenticatedTest, genericTests } from "test/e2e/support/fixtures";
import { TodosLivePage } from "./page";

// generic tests
genericTests.redirectsUnauthenticatedUserToLoginPage(
  "Todos live page",
  TodosLivePage
);

// custom tests
authenticatedTest.describe("[Authenticated] Todos live page", async () => {
  let testPage: TodosLivePage;
  let uniqueTodoContent: string;
  // let persistentTodoContent: string;

  // tests
  authenticatedTest.beforeEach(async ({ page }) => {
    uniqueTodoContent = randomUUID(); // generate random todo content on each test

    // navigate to test page
    testPage = new TodosLivePage(page);
    await testPage.goto();
  });

  authenticatedTest("contains expected title", async () => {
    await expect(testPage.title).toHaveText("Live Todo List");
  });

  authenticatedTest.only("creates a todo", async () => {
    const todoContent = uniqueTodoContent;
    await testPage.todoCreate(todoContent);

    // page contains expected toast message
    const successToast = testPage.toastContainer.locator(".toast-success");
    await expect(successToast).toContainText(testPage.stringTodoCreateSuccess);

    // page contains expected content
    await expect(testPage.todoList).toHaveText(todoContent);
  });

  // can update a todo's content
  // can update a todo's completion status
  // can delete a todo
  // renders expected content when no todo is selected
  // renders expected content when a todo is selected
});
