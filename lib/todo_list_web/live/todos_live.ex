defmodule TodoListWeb.TodosLive do
  use TodoListWeb, :live_view

  alias TodoList.Accounts
  alias TodoList.Todos

  # lifecycle
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    todos = Todos.list_todos_by_user_id(current_user.id)

    socket =
      assign(socket, page_title: "Your Todo List", todos: todos, current_user: current_user)

    {:ok, socket}
  end

  # events
  def handle_event("hello_world", _data, socket) do
    {:noreply, socket}
  end

  def handle_event("todo_create", %{"todo_content" => todo_content} = _data, socket) do
    attrs = %{
      content: todo_content,
      is_completed: false,
      user_id: socket.assigns.current_user.id
    }

    {_status, todo} = Todos.create_todo(attrs)

    socket =
      socket
      |> put_flash(:info, "Item created successfully")
      |> assign(todos: socket.assigns.todos ++ [todo])

    {:noreply, socket}
  end

  def handle_event(
        "todo_toggle_is_completed",
        %{"todo_id" => todo_id, "todo_is_completed" => todo_is_completed} = _data,
        socket
      ) do
    todos = socket.assigns.todos

    # get todo from list
    todo = todos |> Enum.filter(fn todo -> todo.id == todo_id end) |> Enum.at(0)

    # update todo
    {_status, updated_todo} = Todos.update_todo(todo, %{is_completed: !todo_is_completed})

    # put updated todo into todos list
    todos =
      todos
      |> Enum.map(fn t -> if t.id == updated_todo.id, do: updated_todo, else: t end)

    # return modified todos
    {:noreply, socket |> assign(todos: todos)}
  end

  def handle_event(
        "todo_update_content",
        %{"todo_id" => todo_id, "todo_content" => todo_content} = _data,
        socket
      ) do
    todos = socket.assigns.todos

    # cast inputs
    {todo_id, _remainder} = Integer.parse(todo_id)

    # get todo from list
    todo = todos |> Enum.filter(fn todo -> todo.id == todo_id end) |> Enum.at(0)

    # update todo
    {_status, updated_todo} = Todos.update_todo(todo, %{content: todo_content})

    # put updated todo into todos list
    todos =
      todos
      |> Enum.map(fn t -> if t.id == updated_todo.id, do: updated_todo, else: t end)

    # return modified todos and success message
    {:noreply,
     socket
     |> put_flash(:info, "Item updated successfully")
     |> assign(todos: todos)}
  end

  def handle_event("todo_delete", %{"todo_id" => todo_id} = _data, socket) do
    todos = socket.assigns.todos

    # cast inputs
    {todo_id, _remainder} = Integer.parse(todo_id)

    # get todo from list
    todo = todos |> Enum.filter(fn todo -> todo.id == todo_id end) |> Enum.at(0)

    if todo == nil do
      socket = socket.put_flash(:error, "This todo does not exist. Has it already been deleted?")
      throw({:noreply, socket})
    end

    # # delete todo
    # {_status, _deleted_todo} = Todos.delete_todo(todo)
    Todos.delete_todo(todo)

    # if status == :ok do
    # # remove deleted todo into todos list
    todos = todos |> Enum.filter(fn t -> t.id != todo_id end)

    # return modified todos
    socket =
      socket
      |> put_flash(:info, "Item deleted successfully")
      |> assign(todos: todos)

    {:noreply, socket}
    # else
    #   socket = socket |> put_flash(:error, "Item could not be deleted.")
    #   {:noreply, socket}
    # end
  end
end
