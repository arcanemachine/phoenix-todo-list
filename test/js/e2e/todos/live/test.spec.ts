import { expect, Locator } from "@playwright/test";
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
  let createdTodoContent: string;
  let updatedTodoContent: string;

  const generateUniqueTodoContent = () => randomUUID();

  // functions
  async function todoCreate() {
    /** Create a Todo and ensure that it has been created. */
    await testPage.todoCreate(createdTodoContent);

    // sanity check: the form is 'create' mode
    await expect(testPage.todoFormButtonSubmit).toContainText("Create");

    // page contains expected toast message
    const successToast = testPage.toastContainer.locator(".toast-success", {
      hasText: testPage.stringTodoCreateSuccess,
    });
    await expect(successToast).toBeVisible();

    // page contains expected content
    const createdTodo = testPage.todoGetByContent(createdTodoContent);
    await expect(createdTodo).toBeVisible();
  }

  async function todoSelect(todo: Locator) {
    /** Ensure that a Todo has been selected. */
    const todoId = await testPage.todoIdGet(todo);

    // sanity check: the todo is not currently selected
    expect(await testPage.todoIdSelectedGet()).not.toEqual(todoId);

    // select the todo
    await testPage.todoSelect(todo);

    // the todo is now selected
    expect(await testPage.todoIdSelectedGet()).toEqual(todoId);

    // the form is now in 'update' mode
    await expect(testPage.todoFormButtonSubmit).toContainText("Update");
  }

  // tests
  authenticatedTest.beforeEach(async ({ page }) => {
    createdTodoContent = generateUniqueTodoContent();
    updatedTodoContent = generateUniqueTodoContent();

    // navigate to test page
    testPage = new TodosLivePage(page);
    await testPage.goto();
  });

  authenticatedTest("contains expected title", async () => {
    await expect(testPage.pageTitle).toHaveText("Live Todo List");
  });

  authenticatedTest("creates a todo", todoCreate);

  authenticatedTest("selects a todo by clicking it", async () => {
    // create a todo
    await todoCreate();

    // get the todo
    const todo = testPage.todoGetByContent(createdTodoContent);

    // select the todo
    await todoSelect(todo);
  });

  authenticatedTest("un-selects a todo by clicking it again", async () => {
    // create a todo
    await todoCreate();

    // get the todo
    const todo = testPage.todoGetByContent(createdTodoContent);
    const todoId = await testPage.todoIdGet(todo);

    // select the todo
    await todoSelect(todo);

    // click the todo again to un-select it
    const todoButtonContent = testPage.todoButtonContent(todo);
    await todoButtonContent.click();

    // the todo is no longer selected
    expect(await testPage.todoIdSelectedGet()).not.toEqual(todoId);

    // the form is now in 'create' mode
    await expect(testPage.todoFormButtonSubmit).toContainText("Create");
  });

  authenticatedTest("updates a todo's content", async () => {
    const initialTodoContent = createdTodoContent;

    // create a todo
    await todoCreate();

    // get the todo
    const todo = testPage.todoGetByContent(initialTodoContent);

    // update the todo
    await testPage.todoUpdateContent(todo, updatedTodoContent);

    // page contains expected toast message
    await expect
      .soft(testPage.toastContainer)
      .toContainText(testPage.stringTodoUpdateSuccess);

    // page contains expected content
    await expect(
      testPage.todoList.filter({ hasText: updatedTodoContent })
    ).toBeVisible();

    // page no longer contains initial todo content
    await expect(testPage.todoList).not.toContainText(initialTodoContent);
  });

  // authenticatedTest("marks an incomplete todo as completed by clicking the checkbox", async () => {});
  // authenticatedTest("marks a completed todo as incomplete by clicking the checkbox againtjkljkl", async () => {});
  // authenticatedTest("deletes a todo", async () => {});

  // authenticatedTest("shows correct user count when single user is present", async () => {});
});
