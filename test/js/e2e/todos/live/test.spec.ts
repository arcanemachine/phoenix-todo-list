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
  let todoContent: string;

  const generateUniqueTodoContent = () => randomUUID();

  // functions
  async function todoCreate() {
    /** Create a todo and ensure that it has been created. */
    await testPage.todoCreate(todoContent);

    // sanity check: the form is 'create' mode
    await expect.soft(testPage.todoFormButtonSubmit).toContainText("Create");

    // page contains expected toast message
    const successToast = testPage.toastContainer.locator(".toast-success", {
      hasText: testPage.stringTodoCreateSuccess,
    });
    await expect(successToast).toBeVisible();

    // page contains expected content
    const createdTodo = testPage.todoGetByContent(todoContent);
    await expect(createdTodo).toBeVisible();
  }

  // tests
  authenticatedTest.beforeEach(async ({ page }) => {
    todoContent = generateUniqueTodoContent();

    // navigate to test page
    testPage = new TodosLivePage(page);
    await testPage.goto();
  });

  authenticatedTest("contains expected title", async () => {
    await expect(testPage.pageTitle).toHaveText("Live Todo List");
  });

  authenticatedTest("creates a todo", todoCreate);

  authenticatedTest(
    "selects and un-selects a todo by clicking it",
    async () => {
      // create a todo
      await todoCreate();
      const todo = testPage.todoGetByContent(todoContent);
      const todoId = await testPage.todoIdGet(todo);

      // sanity check: the todo is not currently selected
      expect.soft(await testPage.todoIdSelectedGet()).not.toEqual(todoId);

      // select the todo
      const todoContentButton = testPage.todoButtonContent(todo);
      await todoContentButton.click();

      // the todo is now selected
      expect(await testPage.todoIdSelectedGet()).toEqual(todoId);

      // the form is now in 'update' mode
      await expect(testPage.todoFormButtonSubmit).toContainText("Update");

      // click the todo again to un-select it
      await todoContentButton.click();

      // the todo is no longer selected
      expect(await testPage.todoIdSelectedGet()).not.toEqual(todoId);

      // the form is now in 'create' mode
      await expect(testPage.todoFormButtonSubmit).toContainText("Create");
    }
  );

  authenticatedTest("updates a todo's content", async () => {
    const initialTodoContent = todoContent;
    const updatedTodoContent = generateUniqueTodoContent();

    // create a todo
    await todoCreate();

    // get the todo
    const todo = testPage.todoGetByContent(initialTodoContent);

    // select the todo
    const todoContentButton = testPage.todoButtonContent(todo);
    await todoContentButton.click();

    // update the todo
    await testPage.todoUpdateContent(updatedTodoContent);

    // page contains expected toast message
    await expect(testPage.toastContainer).toContainText(
      testPage.stringTodoUpdateSuccess
    );

    // page contains expected content
    await expect(
      testPage.todoList.filter({ hasText: updatedTodoContent })
    ).toBeVisible();

    // page no longer contains initial todo content
    await expect(testPage.todoList).not.toContainText(initialTodoContent);

    // sanity check: the form is now in 'create' mode
    await expect.soft(testPage.todoFormButtonSubmit).toContainText("Create");
  });

  authenticatedTest(
    "toggles a todo's completion status by clicking the checkbox",
    async ({ page }) => {
      // create a todo
      await todoCreate();

      // get the todo
      const todo = page.getByRole("listitem").filter({ hasText: todoContent });

      // sanity check: the todo is incomplete
      expect
        .soft(await todo.getByTestId("is-completed").isVisible())
        .toBe(false);

      // click the checkbox
      const todoCheckboxIsCompleted = testPage.todoCheckboxIsCompletedGet(todo);
      await todoCheckboxIsCompleted.click();

      // page contains expected toast message
      await expect(testPage.toastContainer).toContainText(
        testPage.stringTodoUpdateSuccess
      );
      await testPage.toastClearAll(); // clear toasts

      // the todo is now completed
      expect(await todo.getByTestId("is-completed").isVisible()).toBe(true);

      // click the checkbox again
      await todoCheckboxIsCompleted.click();

      // page contains expected toast message
      await expect(testPage.toastContainer).toContainText(
        testPage.stringTodoUpdateSuccess
      );

      // the todo is now incomplete
      expect(await todo.getByTestId("is-completed").isVisible()).toBe(true);
    }
  );

  authenticatedTest("deletes a todo", async () => {
    // sanity check: the delete modal is not visible
    const todoDeleteModal = testPage.todoDeleteModal;
    expect.soft(await todoDeleteModal.isVisible()).toBe(false);

    // create a todo
    await todoCreate();

    // get the todo
    const todo = testPage.todoGetByContent(todoContent);

    // select the todo
    const todoButtonContent = testPage.todoButtonContent(todo);
    await todoButtonContent.click();

    // click the 'delete' button
    const todoButtonDelete = testPage.todoButtonDeleteGet(todo);
    await todoButtonDelete.click();

    // the delete modal is now visible
    await expect(todoDeleteModal).toBeVisible();

    // click the confirmation button
    const todoDeleteModalButtonConfirm = testPage.todoDeleteModalButtonConfirm;
    await todoDeleteModalButtonConfirm.click();

    // page contains expected toast message
    await expect(testPage.toastContainer).toContainText(
      testPage.stringTodoDeleteSuccess
    );

    // page no longer contains todo
    await expect(testPage.todoList).not.toContainText(todoContent);
  });

  // authenticatedTest(
  //   "shows correct user count when single window is viewing the page",
  //   async () => {}
  // );
  // authenticatedTest(
  //   "shows correct user count when multiple windows are viewing the page",
  //   async () => {}
  // );

  // authenticatedTest(
  //   "shows correct message when current window creates a todo",
  //   async () => {}
  // );
  // authenticatedTest(
  //   "shows correct message when other window creates a todo",
  //   async () => {}
  // );

  // authenticatedTest(
  //   "shows correct message when current window updates a todo's content",
  //   async () => {}
  // );
  // authenticatedTest(
  //   "shows correct message when other window updates a todo's content",
  //   async () => {}
  // );
  // authenticatedTest(
  //   "shows correct message when current window updates a todo's completion status",
  //   async () => {}
  // );
  // authenticatedTest(
  //   "shows correct message when other window updates a todo's completion status",
  //   async () => {}
  // );
  // authenticatedTest(
  //   "shows correct message when current window deletes a todo",
  //   async () => {}
  // );
  // authenticatedTest(
  //   "shows correct message when other window updates a todo's completion status",
  //   async () => {}
  // );
});
