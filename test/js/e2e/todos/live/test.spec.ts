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
    await testPage.toastClear(); // clear toast messages

    // get the todo that will be updated
    const todo = testPage.todoGetByContent(originalTodoContent);

    // update the todo
    await testPage.todoUpdateContent(todo, updatedTodoContent);
    await testPage.page.pause();

    // page contains expected toast message
    await expect(testPage.toastContainer).toContainText(
      testPage.stringTodoUpdateSuccess
    );

    // page contains expected content
    await expect(testPage.todoList).toHaveText(updatedTodoContent);

    // page no longer contains original todo content
    await expect(testPage.todoList).not.toHaveText(originalTodoContent);
  });

  // authenticatedTest("marks an incomplete todo as completed by clicking the checkbox", async () => {});
  // authenticatedTest("marks a completed todo as incomplete by clicking the checkbox againtjkljkl", async () => {});
  // authenticatedTest("deletes a todo", async () => {});

  // authenticatedTest("shows correct user count when single user is present", async () => {});
});
