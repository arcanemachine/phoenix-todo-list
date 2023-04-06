defmodule TodoList.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoList.Todos` context.
  """

  import TodoList.AccountsFixtures

  # def valid_todo_content, do: "some todo content"
  def valid_todo_content, do: TodoList.Helpers.generate_random_string()

  def valid_todo_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      content: valid_todo_content(),
      # generate a random boolean
      is_completed: :rand.uniform() > 0.5
    })
  end

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    # generate user
    user_id = attrs[:user_id] || user_fixture().id

    {:ok, todo} =
      attrs
      |> Enum.into(%{
        content: valid_todo_content(),
        is_completed: true,
        user_id: user_id
      })
      |> TodoList.Todos.create_todo()

    todo
  end
end
