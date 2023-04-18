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
    await expect(testPage.toastContainer).toContainText(
      testPage.stringTodoCreateSuccess
    );

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
      await expect.soft(todo.getByTestId("is-completed")).not.toBeVisible();

      // click the checkbox
      const todoCheckboxIsCompleted = testPage.todoCheckboxIsCompletedGet(todo);
      await todoCheckboxIsCompleted.click();

      // page contains expected toast message
      await expect(testPage.toastContainer).toContainText(
        testPage.stringTodoUpdateSuccess
      );
      await testPage.toastClearAll(); // clear toasts

      // the todo is now completed
      await expect(todo.getByTestId("is-completed")).toBeVisible();

      // click the checkbox again
      await todoCheckboxIsCompleted.click();

      // page contains expected toast message
      await expect(testPage.toastContainer).toContainText(
        testPage.stringTodoUpdateSuccess
      );

      // the todo is now incomplete
      await expect(todo.getByTestId("is-completed")).not.toBeVisible();
    }
  );

  authenticatedTest("deletes a todo", async () => {
    // sanity check: the delete modal is not visible
    const todoDeleteModal = testPage.todoDeleteModal;
    await expect.soft(todoDeleteModal).not.toBeVisible();

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

    // page no longer contains deleted todo
    await expect(testPage.todoList).not.toContainText(todoContent);
  });

  authenticatedTest(
    "shows correct user count when the page is open in a single window",
    async () => {
      // page contains expected content
      await expect(testPage.userCounter).toContainText(
        "1 user viewing this page"
      );
    }
  );

  authenticatedTest(
    "shows correct user count when multiple windows are viewing the page",
    async ({ context }) => {
      // initialize page 2
      const page2 = await context.newPage();
      const testPage2 = new TodosLivePage(page2);

      // navigate to test URL
      await testPage2.goto();

      // both pages contain expected content
      await expect(testPage.userCounter).toContainText(
        "2 users viewing this page"
      );
      await expect(testPage2.userCounter).toContainText(
        "2 users viewing this page"
      );
    }
  );

  authenticatedTest("creates a todo in another window", async ({ context }) => {
    // initialize page 2
    const page2 = await context.newPage();
    const testPage2 = new TodosLivePage(page2);
    await testPage2.goto(); // navigate to test URL

    // create a todo on page 1
    await todoCreate();

    // page 2 contains expected toast message
    await expect(testPage2.toastContainer).toContainText(
      testPage.stringOtherWindowTodoCreateSuccess
    );

    // page 2 contains expected content
    const createdTodo = testPage2.todoGetByContent(todoContent);
    await expect(createdTodo).toBeVisible();
  });

  authenticatedTest(
    "update's a todo's content in another window",
    async ({ context }) => {
      const initialTodoContent = todoContent;
      const updatedTodoContent = generateUniqueTodoContent();

      // initialize page 2
      const page2 = await context.newPage();
      const testPage2 = new TodosLivePage(page2);
      await testPage2.goto(); // navigate to test URL

      // create a todo on page 1
      await todoCreate();

      // get the todo on page 1
      const todo = testPage.todoGetByContent(initialTodoContent);

      // select the todo on page 1
      const todoContentButton = testPage.todoButtonContent(todo);
      await todoContentButton.click();

      // update the todo on page 1
      await testPage.todoUpdateContent(updatedTodoContent);

      // page 2 contains expected toast message
      await expect(testPage2.toastContainer).toContainText(
        testPage.stringOtherWindowTodoUpdateSuccess
      );

      // page 2 contains expected content
      await expect(
        testPage2.todoList.filter({ hasText: updatedTodoContent })
      ).toBeVisible();

      // page 2 no longer contains initial todo content
      await expect(testPage2.todoList).not.toContainText(initialTodoContent);
    }
  );

  authenticatedTest(
    "updates a todo's completion status in another window",
    async ({ page, context }) => {
      // initialize page 2
      const page2 = await context.newPage();
      const testPage2 = new TodosLivePage(page2);
      await testPage2.goto(); // navigate to test URL

      // create a todo on page 1
      await todoCreate();

      // get the todo in both pages
      const page1Todo = page
        .getByRole("listitem")
        .filter({ hasText: todoContent });
      const page2Todo = page2
        .getByRole("listitem")
        .filter({ hasText: todoContent });

      // click the checkbox on page 1
      const todoCheckboxIsCompleted =
        testPage.todoCheckboxIsCompletedGet(page1Todo);
      await todoCheckboxIsCompleted.click();

      // page 2 contains expected toast message
      await expect(testPage2.toastContainer).toContainText(
        testPage.stringOtherWindowTodoUpdateSuccess
      );
      await testPage2.toastClearAll(); // clear toasts

      // the todo is now completed on page 2
      await expect(page2Todo.getByTestId("is-completed")).toBeVisible();

      // click the checkbox again on page 1
      await todoCheckboxIsCompleted.click();

      // page 2 contains expected toast message
      await expect(testPage2.toastContainer).toContainText(
        testPage.stringOtherWindowTodoUpdateSuccess
      );

      // the todo is now incomplete on page 2
      await expect(page2Todo.getByTestId("is-completed")).not.toBeVisible();
    }
  );

  authenticatedTest("deletes a todo in another window", async ({ context }) => {
    // initialize page 2
    const page2 = await context.newPage();
    const testPage2 = new TodosLivePage(page2);
    await testPage2.goto(); // navigate to test URL

    // create a todo on page 1
    await todoCreate();

    // get the todo on page 1
    const todo = testPage.todoGetByContent(todoContent);

    // select the todo on page 1
    const todoButtonContent = testPage.todoButtonContent(todo);
    await todoButtonContent.click();

    // click the 'delete' button on page 1
    const todoButtonDelete = testPage.todoButtonDeleteGet(todo);
    await todoButtonDelete.click();

    // click the confirmation button on page 1
    const todoDeleteModalButtonConfirm = testPage.todoDeleteModalButtonConfirm;
    await todoDeleteModalButtonConfirm.click();

    // page 2 contains expected toast message
    await expect(testPage2.toastContainer).toContainText(
      testPage.stringOtherWindowTodoDeleteSuccess
    );

    // page 2 no longer contains deleted todo
    await expect(testPage2.todoList).not.toContainText(todoContent);
  });
});
