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
authenticatedTest.describe.only("[Authenticated] Todos live page", async () => {
  let testPage: TodosLivePage;
  // let persistentTodoContent: string;

  const generateUniqueTodoContent = () => randomUUID();

  // tests
  authenticatedTest.beforeEach(async ({ page }) => {
    // navigate to test page
    testPage = new TodosLivePage(page);
    await testPage.goto();
  });

  authenticatedTest("contains expected title", async () => {
    await expect(testPage.pageTitle).toHaveText("Live Todo List");
  });

  authenticatedTest("creates a todo", async () => {
    const todoContent = generateUniqueTodoContent();
    await testPage.todoCreate(todoContent);

    // page contains expected toast message
    const successToast = testPage.toastContainer.locator(".toast-success", {
      hasText: testPage.stringTodoCreateSuccess,
    });
    await expect(successToast).toBeVisible();

    // page contains expected content
    await expect(testPage.todoList).toHaveText(todoContent);
  });

  // authenticatedTest("selects a todo by clicking it", async () => {});
  // authenticatedTest("un-selects a todo by clicking it again", async () => {});

  authenticatedTest("updates a todo's content", async () => {
    const originalTodoContent = generateUniqueTodoContent();
    const updatedTodoContent = generateUniqueTodoContent();

    // setup
    await testPage.todoCreate(originalTodoContent);

    // get the todo that will be updated
    const todo = await testPage.todoGetByContent(originalTodoContent);

    // update the todo
    await testPage.todoUpdateContent(todo, updatedTodoContent);

    // page contains expected toast message
    const successToast = testPage.toastContainer.locator(".toast-success", {
      hasText: testPage.stringTodoUpdateSuccess,
    });
    await expect(successToast).toBeVisible();

    // page contains expected content
    await expect(testPage.todoList).toHaveText(updatedTodoContent);

    // // page contains expected toast message
    // const successToast = testPage.toastContainer.locator(".toast-success");
    // await expect(successToast).toContainText(testPage.stringTodoCreateSuccess);

    // // todo contains expected content
    // await expect(testPage.todoList).toHaveText(todoContent);

    // page no longer contains original todo content
  });

  // authenticatedTest("marks an incomplete todo as completed by clicking the checkbox", async () => {});
  // authenticatedTest("marks a completed todo as incomplete by clicking the checkbox again", async () => {});
  // authenticatedTest("deletes a todo", async () => {});
});
