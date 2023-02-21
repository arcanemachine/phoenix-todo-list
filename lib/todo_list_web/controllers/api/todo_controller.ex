defmodule TodoListWeb.Api.TodoController do
  use TodoListWeb, :controller

  alias TodoList.Todos
  alias TodoList.Todos.Todo

  action_fallback TodoListWeb.FallbackController

  def index(conn, _params) do
    todos = Todos.list_todos_by_user_id(conn.assigns.current_user.id)
    render(conn, :index, todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    # set user_id to current user
    todo_params = Map.merge(todo_params, %{"user_id" => conn.assigns.current_user.id})

    with {:ok, %Todo{} = todo} <- Todos.create_todo(todo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/todos/#{todo.id}")
      |> render(:show, todo: todo)
    end
  end

  def show(conn, _params) do
    todo = conn.assigns.todo

    render(conn, :show, todo: todo)
  end

  def update(conn, %{"todo" => todo_params}) do
    todo = conn.assigns.todo

    with {:ok, %Todo{} = todo} <- Todos.update_todo(todo, todo_params) do
      render(conn, :show, todo: todo)
    end
  end

  def delete(conn, _params) do
    todo = conn.assigns.todo

    with {:ok, %Todo{}} <- Todos.delete_todo(todo) do
      send_resp(conn, :no_content, "")
    end
  end
end
