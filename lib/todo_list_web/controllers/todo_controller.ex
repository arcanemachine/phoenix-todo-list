defmodule TodoListWeb.TodoController do
  use TodoListWeb, :controller

  alias TodoList.Todos
  alias TodoList.Todos.Todo

  def index(conn, _params) do
    todos = Todos.list_todos_by_user_id(conn.assigns.current_user.id)
    render(conn, :index, todos: todos)
  end

  def new(conn, _params) do
    changeset = Todos.change_todo(%Todo{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"todo" => todo_params}) do
    # set user_id to current user
    user = conn.assigns.current_user
    todo_params = Map.merge(todo_params, %{user_id: user.id})

    case Todos.create_todo(todo_params) do
      {:ok, todo} ->
        conn
        |> put_flash(:info, "Todo created successfully.")
        |> redirect(to: ~p"/todos/#{todo}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    render(conn, :show, todo: todo)
  end

  def edit(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    changeset = Todos.change_todo(todo)
    render(conn, :edit, todo: todo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = Todos.get_todo!(id)

    case Todos.update_todo(todo, todo_params) do
      {:ok, todo} ->
        conn
        |> put_flash(:info, "Todo updated successfully.")
        |> redirect(to: ~p"/todos/#{todo}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, todo: todo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    {:ok, _todo} = Todos.delete_todo(todo)

    conn
    |> put_flash(:info, "Todo deleted successfully.")
    |> redirect(to: ~p"/todos")
  end
end
