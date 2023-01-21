defmodule TodoListWeb.TodosLive do
  use TodoListWeb, :live_view

  alias TodoList.Accounts
  alias TodoList.Todos

  # lifecycle
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    todos = Todos.list_todos_by_user_id(current_user.id)

    socket = assign(socket, page_title: "Your Todos", todos: todos, todo_id_selected: 0)

    {:ok, socket}
  end

  # def render(assigns) do
  #   ~H"""
  #   <.todo_list todos={@todos} />
  #   """
  # end

  # methods
  def todo_handle_click(todo_id) do
  end

  def todo_update_is_completed(todo_id) do
  end

  def show_todo_delete_modal(todo_id) do
  end

  def hide_todo_delete_modal() do
  end
end
