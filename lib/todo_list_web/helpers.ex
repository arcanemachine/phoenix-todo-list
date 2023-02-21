defmodule TodoListWeb.Helpers.Controller do
  @moduledoc "Generic controller helper functions."

  def http_response_403(conn) do
    conn
    |> Plug.Conn.put_status(403)
    |> Phoenix.Controller.text("403 Forbidden")
    |> Plug.Conn.halt()
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
  @moduledoc "Helper functions for use in templates."

  @doc "Determine the platform used by reading the `x-requested-with` header."
  def detect_platform(conn) do
    (Enum.member?(conn.req_headers, {"x-platform", "flutter"}) && "flutter") || "web"
  end
end
