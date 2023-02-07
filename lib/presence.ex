defmodule TodoList.Presence do
  @moduledoc """
  The Presence module.
  """
  use Phoenix.Presence,
    otp_app: :todo_list,
    pubsub_server: TodoList.PubSub
end
