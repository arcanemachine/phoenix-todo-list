defmodule TodoListWeb.TodoListLive do
  use TodoListWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Your Todos</h1>
    """
  end
end
