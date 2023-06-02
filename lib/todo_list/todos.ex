defmodule TodoList.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias TodoList.Repo

  alias TodoList.Todos.Todo
  alias TodoList.Accounts.User

  @doc """
  Returns a paginated list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  @spec list_todos(map) ::
          {:ok, {[Todo.t()], Flop.Meta.t()}} | {:error, Flop.Meta.t()}
  def list_todos(params \\ %{}, %User{} = user \\ %User{}) do
    Todo |> scope(user) |> Flop.validate_and_run(params, for: Todo)
  end

  defp scope(q, %User{id: user_id}) when is_nil(user_id), do: q
  defp scope(q, %User{id: user_id}), do: where(q, user_id: ^user_id)
  defp scope(q, %User{}), do: q

  @doc """
  Get a complete list of todos by user ID.

  ## Examples

      iex> list_todos_by_user_id(123)
      [%Todo{}, ...]

      iex> list_todos_by_user_id(456)
      ** (Ecto.NoResultsError)

  """
  def list_todos_by_user_id(user_id) do
    query = from(Todo, where: [user_id: ^user_id], order_by: :id)
    Repo.all(query)
  end

  @doc """
  Get a paginated list of todos by user ID.

  ## Examples

      iex> list_todos_by_user_id(%{}, 123)
      [%Todo{}, ...]

      iex> list_todos_by_user_id(%{}, 456)
      ** (Ecto.NoResultsError)

  """
  @spec list_todos_by_user_id(map, integer) ::
          {:ok, {[Todo.t()], Flop.Meta.t()}} | {:error, Flop.Meta.t()}
  def list_todos_by_user_id(params, user_id) do
    Todo |> where(user_id: ^user_id) |> Flop.validate_and_run(params, for: Todo)
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id), do: Repo.get!(Todo, id)

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end
end
