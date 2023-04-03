defmodule TodoListWeb.Test.GenericTests do
  @moduledoc "Reusable tests"

  defmacro requires_authenticated_api_user(url, method \\ "get") do
    quote do
      test "returns 401 for unauthenticated API user: #{unquote(method)}", %{conn: conn} do
        url = unquote(url)
        method = unquote(method)

        # ensure user is unauthenticated
        conn = logout_api_user(conn)

        # make request
        conn =
          case method do
            "get" -> get(conn, url)
            "post" -> post(conn, url)
            "put" -> put(conn, url)
            "patch" -> patch(conn, url)
          end

        # response has expected status code and body
        assert conn.status == 401
        assert conn.resp_body =~ "This endpoint is only accessible to authenticated users."
      end
    end
  end
end
