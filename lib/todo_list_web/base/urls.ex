defmodule TodoListWeb.Base.Urls do
  @moduledoc "Django-style named URL routes."

  def path(name, _opts) do
    case name do
      "project_root" -> "/"
      _ -> nil
    end
  end

  def path(name) do
    path(name, [])
  end
end
