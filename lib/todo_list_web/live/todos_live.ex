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
  def handle_event("todo_create", %{"todo_content" => todo_content} = _data, socket) do
    try do
      attrs = %{
        content: todo_content,
        is_completed: false,
        user_id: socket.assigns.current_user.id
      }

      {_status, todo} = Todos.create_todo(attrs)

      {:noreply,
       socket
       |> push_event("todo-create-success", %{})
       |> assign(todos: socket.assigns.todos ++ [todo])}
    rescue
      _ ->
        {:noreply, socket |> toast_error("Item could not be created.")}
    end
  end

  def handle_event(
        "todo_toggle_is_completed",
        %{"todo_id" => todo_id, "todo_is_completed" => todo_is_completed} = _data,
        socket
      ) do
    try do
      # get todo
      todos = socket.assigns.todos
      todo = todos |> Enum.filter(fn todo -> todo.id == todo_id end) |> Enum.at(0)

      # update todo
      {_status, updated_todo} = Todos.update_todo(todo, %{is_completed: !todo_is_completed})

      # merge updated todo into todos list
      todos =
        todos
        |> Enum.map(fn t -> if t.id == updated_todo.id, do: updated_todo, else: t end)

      {:noreply, socket |> toast_success("Item updated successfully") |> assign(todos: todos)}
    rescue
      _ -> {:noreply, socket |> toast_error("Item could not be updated.")}
    end
  end

  def handle_event(
        "todo_update_content",
        %{"todo_id" => todo_id, "todo_content" => todo_content} = data,
        socket
      ) do
    # get todo from list
    try do
      # cast inputs
      {todo_id, _remainder} = Integer.parse(todo_id)

      # get todo
      todos = socket.assigns.todos
      todo = todos |> Enum.filter(fn todo -> todo.id == todo_id end) |> Enum.at(0)

      # update todo
      {_status, updated_todo} = Todos.update_todo(todo, %{content: todo_content})

      # merge updated todo into todos list
      todos =
        todos
        |> Enum.map(fn t -> if t.id == updated_todo.id, do: updated_todo, else: t end)

      IO.puts("Before: #{todo.content}")
      IO.puts("After: #{updated_todo.content}")

      {:noreply,
       socket |> push_event("todo-update-content-success", data) |> assign(todos: todos)}
    rescue
      _ -> {:noreply, socket |> toast_error("Item could not be updated.")}
    end
  end

  def handle_event("todo_delete", %{"todo_id" => todo_id} = _data, socket) do
    try do
      # cast inputs
      {todo_id, _remainder} = Integer.parse(todo_id)

      # delete todo
      todo = socket.assigns.todos |> Enum.filter(fn todo -> todo.id == todo_id end) |> Enum.at(0)
      Todos.delete_todo(todo)

      # remove deleted todo from todos list
      todos = socket.assigns.todos |> Enum.filter(fn t -> t.id != todo_id end)

      {:noreply,
       socket |> push_event("todo-delete-success", %{todo_id: todo_id}) |> assign(todos: todos)}
    rescue
      _ -> {:noreply, socket |> toast_error("Item could not be deleted.")}
    end
  end

  # helpers
  def toast_show(socket, content, theme) do
    push_event(socket, "toast-show", %{content: content, theme: theme})
  end

  def toast_success(socket, content) do
    toast_show(socket, content, "success")
  end

  def toast_error(socket, content) do
    toast_show(socket, content, "error")
  end
end
