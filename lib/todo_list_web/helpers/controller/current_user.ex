defmodule TodoListWeb.Helpers.Controller.CurrentUser do
  defmacro __using__(_) do
    quote do
      def action(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _opts) do
        apply(__MODULE__, action_name(conn), [conn, conn.params, current_user])
      end
    end
  end
end
