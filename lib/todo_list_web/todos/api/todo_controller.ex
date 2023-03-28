defmodule TodoListWeb.Api.TodoController do
  use TodoListWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias TodoList.Todos
  alias TodoList.Todos.Todo
  alias TodoListWeb.Schemas
  alias TodoListWeb.Schemas.GenericResponses

  action_fallback TodoListWeb.FallbackController

  tags ["todos"]

  operation :index,
    summary: "List todo items",
    security: [%{"bearerAuth" => []}],
    responses: %{
      200 => {"OK", "application/json", Schemas.TodoListResponse200},
      401 => GenericResponses.response_401_authentication_required()
    }

  def index(conn, _params) do
    todos = Todos.list_todos_by_user_id(conn.assigns.current_user.id)
    render(conn, :index, todos: todos)
  end

  operation :create,
    summary: "Create new todo item",
    security: [%{"bearerAuth" => []}],
    request_body: {"Todo creation request", "application/json", Schemas.TodoCreateRequest},
    responses: %{
      201 => {"Created", "application/json", Schemas.TodoCreateResponse201},
      400 => GenericResponses.response_400(),
      401 => GenericResponses.response_401_authentication_required()
    }

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
