defmodule TodoList.Repo do
  use Ecto.Repo,
    otp_app: :todo_list,
    adapter: Ecto.Adapters.SQLite3
end
