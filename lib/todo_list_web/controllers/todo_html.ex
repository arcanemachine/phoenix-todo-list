defmodule TodoListWeb.TodoHTML do
  @moduledoc false

  use TodoListWeb, :html

  embed_templates "todo_html/*"
end
