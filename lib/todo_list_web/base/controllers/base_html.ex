defmodule TodoListWeb.BaseHTML do
  @moduledoc false

  use TodoListWeb, :html

  embed_templates "base_html/*"
end
