defmodule TodoList.Repo do
  use Ecto.Repo,
    otp_app: :todo_list,
    adapter: Ecto.Adapters.Postgres
end
