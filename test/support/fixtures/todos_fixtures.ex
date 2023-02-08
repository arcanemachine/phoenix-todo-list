defmodule TodoList.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoList.Todos` context.
  """

  import TodoList.AccountsFixtures

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    # generate user
    user_id = attrs[:user_id] || user_fixture().id

    {:ok, todo} =
      attrs
      |> Enum.into(%{
        content: "some content",
        is_completed: true,
        user_id: user_id
      })
      |> TodoList.Todos.create_todo()

    todo
  end
end
