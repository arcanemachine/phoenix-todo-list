defmodule TodoListWeb.TodosLive do
  use TodoListWeb, :live_view

  alias TodoList.Accounts
  alias TodoList.Todos

  # lifecycle
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    todos = Todos.list_todos_by_user_id(current_user.id)

    socket = assign(socket, page_title: "Your Todos", todos: todos, current_user: current_user)

    {:ok, socket}
  end

  # def render(assigns) do
  #   ~H"""
  #   <.todo_list todos={@todos} />
  #   """
  # end

  # methods
  def handle_event("todo_create", %{"content" => content} = data, socket) do
    attrs = %{
      content: content,
      is_completed: false,
      user_id: socket.assigns.current_user.id
    }

    {_status, todo} = Todos.create_todo(attrs)

    socket = socket |> assign(todos: socket.assigns.todos ++ [todo])

    {:noreply, socket}
  end

  def todo_item_handle_click(todo_id) do
  end

  def handle_event(
        "todo_toggle_is_completed",
        %{"todo_id" => todo_id, "todo_is_completed" => todo_is_completed} = _data,
        socket
      ) do
    todos = socket.assigns.todos

    # cast inputs
    {todo_id, _remainder} = Integer.parse(todo_id)
    todo_is_completed = (todo_is_completed == "true" && true) || false

    # get todo from list
    todo = todos |> Enum.filter(fn todo -> todo.id == todo_id end) |> Enum.at(0)

    # update todo
    {_status, updated_todo} = Todos.update_todo(todo, %{is_completed: !todo_is_completed})

    # insert updated todo into todos list
    todos =
      todos
      |> Enum.map(fn todo -> if todo.id == updated_todo.id, do: updated_todo, else: todo end)

    {:noreply, socket |> assign(todos: todos)}
  end

  def handle_event("hello_world", _data, socket) do
    {:noreply, socket}
  end

  def show_todo_delete_modal(_todo_id) do
  end

  def hide_todo_delete_modal() do
  end
end
