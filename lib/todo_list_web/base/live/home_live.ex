defmodule TodoListWeb.HomeLive do
  use TodoListWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(page_title: "Home")}
  end
end
