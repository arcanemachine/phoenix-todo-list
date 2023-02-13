defmodule TodoListWeb.Helpers.Ecto do
  @moduledoc """
  Helper functions for Ecto.
  """
  def changeset_errors_to_json(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
