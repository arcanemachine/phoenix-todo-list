defmodule TodoListWeb.TodoController do
  use TodoListWeb, :controller

  alias TodoList.Todos
  alias TodoList.Todos.Todo

  def index(conn, _params) do
    todos = Todos.list_todos_by_user_id(conn.assigns.current_user.id)
    render(conn, :index, todos: todos, page_title: "Todo List")
  end

  def new(conn, _params) do
    changeset = Todos.change_todo(%Todo{})
    render(conn, :new, changeset: changeset, page_title: "Create Todo")
  end

  def create(conn, %{"todo" => todo_params}) do
    # set user_id to current user
    todo_params = Map.merge(todo_params, %{"user_id" => conn.assigns.current_user.id})

    case Todos.create_todo(todo_params) do
      {:ok, todo} ->
        conn
        |> put_flash(:info, "Todo created successfully")
        |> redirect(to: ~p"/todos/#{todo}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, page_title: "Create Todo", changeset: changeset)
    end
  end

  def show(conn, _params) do
    conn
    |> render(:show, page_title: "Todo Info (##{conn.assigns.todo.id})", todo: conn.assigns.todo)
  end

  def edit(conn, _params) do
    todo = conn.assigns.todo
    changeset = Todos.change_todo(todo)
    render(conn, :edit, page_title: "Edit Todo", todo: todo, changeset: changeset)
  end

  def update(conn, %{"todo" => todo_params}) do
    todo = conn.assigns.todo

    case Todos.update_todo(todo, todo_params) do
      {:ok, _todo} ->
        conn
        |> put_flash(:info, "Todo updated successfully")
        |> redirect(to: ~p"/todos")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, page_title: "Edit Todo", todo: todo, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    todo = conn.assigns.todo
    {:ok, _todo} = Todos.delete_todo(todo)

    conn
    |> put_flash(:info, "Todo deleted successfully")
    |> redirect(to: ~p"/todos")
  end
end
