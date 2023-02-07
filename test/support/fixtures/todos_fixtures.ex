defmodule TodoList.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoList.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        content: "some content",
        is_completed: true,
        user_id: 1
      })
      |> TodoList.Todos.create_todo()

    todo
  end
end
