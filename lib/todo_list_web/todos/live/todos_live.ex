defmodule TodoListWeb.TodosLive do
  use Phoenix.Component, global_prefixes: ~w(x-)
  use TodoListWeb, :live_view

  alias TodoList.Accounts
  alias TodoList.Todos
  alias TodoList.Presence
  alias TodoListWeb.Endpoint

  @channels_topic "todos_live"
  @presence_topic "todos_live"

  # lifecycle
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    todos = Todos.list_todos_by_user_id(current_user.id)

    # channels #
    user_channels_topic = "#{@channels_topic}:#{current_user.id}"

    if connected?(socket) do
      # subscribe to channel
      Endpoint.subscribe(user_channels_topic)
    end

    # presence #
    user_presence_topic = "#{@presence_topic}:#{current_user.id}"
    Presence.track(self(), user_presence_topic, socket.id, %{})

    initial_user_count = Presence.list(user_presence_topic) |> map_size() |> Kernel.-(1)

    socket =
      assign(socket,
        socket_id: socket.id,
        page_title: "Live Todo List",
        todos: todos,
        current_user: current_user,
        user_count: initial_user_count
      )

    {:ok, socket}
  end

  # presence
  def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
        %{assigns: %{user_count: user_count}} = socket
      ) do
    # update user count
    new_user_count = user_count + map_size(joins) - map_size(leaves)

    {:noreply, assign(socket, :user_count, new_user_count)}
  end

  # channels
  def handle_info(%{:event => "todo_create"} = msg, socket) do
    socket =
      if msg.payload.socket_id === socket.id,
        do: socket |> push_event("todo-create-success", %{}),
        else: socket |> toast_success("Item created in another window")

    {:noreply, assign(socket, todos: msg.payload.todos)}
  end

  def handle_info(%{:event => "todo_toggle_is_completed"} = msg, socket) do
    socket =
      if msg.payload.socket_id === socket.id,
        do: socket |> push_event("todo-toggle-is-completed-success", %{}),
        else: socket |> toast_success("Item updated in another window")

    {:noreply, assign(socket, todos: msg.payload.todos)}
  end

  def handle_info(%{:event => "todo_update_content"} = msg, socket) do
    socket =
      if msg.payload.socket_id === socket.id,
        do: socket |> push_event("todo-update-content", %{}),
        else: socket |> toast_success("Item updated in another window")

    {:noreply, assign(socket, todos: msg.payload.todos)}
  end

  def handle_info(%{:event => "todo_delete"} = msg, socket) do
    socket =
      if msg.payload.socket_id === socket.id,
        do: socket |> push_event("todo-delete-success", %{}),
        else: socket |> toast_success("Item deleted in another window")

    {:noreply, assign(socket, todos: msg.payload.todos)}
  end

  # events
  def handle_event("todo_create", %{"content" => content} = _data, socket) do
    try do
      attrs = %{
        content: content,
        is_completed: false,
        user_id: socket.assigns.current_user.id
      }

      {_status, todo} = Todos.create_todo(attrs)

      socket =
        socket
        |> update(:todos, &(&1 ++ [todo]))

      # broadcast assigns to channel
      Endpoint.broadcast(
        "#{@channels_topic}:#{socket.assigns.current_user.id}",
        "todo_create",
        socket.assigns
      )

      {:noreply, socket}
    rescue
      _ ->
        {:noreply, socket |> toast_error("Item could not be created.")}
    end
  end

  def handle_event(
        "todo_toggle_is_completed",
        %{"id" => todo_id} = _data,
        socket
      ) do
    try do
      # get todo
      todos = socket.assigns.todos
      todo = todos |> Enum.filter(fn todo -> todo.id === todo_id end) |> Enum.at(0)

      # update todo
      {_status, updated_todo} = Todos.update_todo(todo, %{is_completed: !todo.is_completed})

      # merge updated todo into todos list
      todos =
        todos
        |> Enum.map(fn t -> if t.id === updated_todo.id, do: updated_todo, else: t end)

      socket = socket |> assign(todos: todos)

      # broadcast assigns to channel
      Endpoint.broadcast(
        "#{@channels_topic}:#{socket.assigns.current_user.id}",
        "todo_toggle_is_completed",
        socket.assigns
      )

      {:noreply, socket}
    rescue
      _ -> {:noreply, socket |> toast_error("Item could not be updated.")}
    end
  end

  def handle_event(
        "todo_update_content",
        %{"id" => todo_id, "content" => todo_content} = data,
        socket
      ) do
    # get todo from list
    try do
      # cast inputs
      {todo_id, _remainder} = Integer.parse(todo_id)

      # get todo
      todos = socket.assigns.todos
      todo = todos |> Enum.filter(fn todo -> todo.id === todo_id end) |> Enum.at(0)

      # update todo
      {_status, updated_todo} = Todos.update_todo(todo, %{content: todo_content})

      # merge updated todo into todos list
      todos =
        todos
        |> Enum.map(fn t -> if t.id === updated_todo.id, do: updated_todo, else: t end)

      socket = socket |> push_event("todo-update-content-success", data) |> assign(todos: todos)

      # broadcast assigns to channel
      Endpoint.broadcast(
        "#{@channels_topic}:#{socket.assigns.current_user.id}",
        "todo_update_content",
        socket.assigns
      )

      {:noreply, socket}
    rescue
      _ -> {:noreply, socket |> toast_error("Item could not be updated.")}
    end
  end

  def handle_event("todo_delete", %{"id" => todo_id} = _data, socket) do
    try do
      # cast inputs
      {todo_id, _remainder} = Integer.parse(todo_id)

      # delete todo
      todo = socket.assigns.todos |> Enum.filter(fn todo -> todo.id === todo_id end) |> Enum.at(0)
      Todos.delete_todo(todo)

      # remove deleted todo from todos list
      todos = socket.assigns.todos |> Enum.filter(fn t -> t.id !== todo_id end)

      socket = socket |> assign(todos: todos)

      # broadcast assigns to channel
      Endpoint.broadcast(
        "#{@channels_topic}:#{socket.assigns.current_user.id}",
        "todo_delete",
        socket.assigns
      )

      {:noreply, socket}
    rescue
      _ -> {:noreply, socket |> push_event("todo-delete-error", %{todo_id: todo_id})}
    end
  end

  # helpers
  def toast_show(socket, content, theme \\ "primary") do
    push_event(socket, "toast-show", %{content: content, theme: theme})
  end

  def toast_success(socket, content) do
    toast_show(socket, content, "success")
  end

  def toast_error(socket, content) do
    toast_show(socket, content, "error")
  end
end
