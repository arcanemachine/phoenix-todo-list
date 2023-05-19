defmodule TodoListWeb.Helpers.Controller do
  @moduledoc "Generic controller helper functions."

  import Plug.Conn

  def http_response_403(conn) do
    conn
    |> put_status(:forbidden)
    |> Phoenix.Controller.text("403 Forbidden")
    |> halt()
  end

  def json_response_400(conn, message \\ "Bad Request") do
    conn |> put_status(:bad_request) |> Phoenix.Controller.json(%{message: message}) |> halt()
  end

  def json_response_403(conn) do
    conn |> put_status(:forbidden) |> Phoenix.Controller.json(%{message: "Forbidden"}) |> halt()
  end
end

defmodule TodoListWeb.Helpers.Ecto do
  @moduledoc "Helper functions for Ecto."

  def changeset_errors_to_json(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end

defmodule TodoListWeb.Helpers.Template do
  @moduledoc "Helper functions templates."
end
