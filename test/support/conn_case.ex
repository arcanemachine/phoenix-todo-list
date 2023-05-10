defmodule TodoListWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use TodoListWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint TodoListWeb.Endpoint

      use TodoListWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import TodoListWeb.ConnCase
    end
  end

  setup tags do
    TodoList.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in users.

      setup :register_and_login_user

  It stores an updated connection and a registered user in the
  test context.
  """
  def register_and_login_user(%{conn: conn}) do
    user = TodoList.AccountsFixtures.user_fixture()
    %{conn: login_user(conn, user), user: user}
  end

  @doc """
  Simulate a logged-in user by adding the expected request headers.

      setup :register_and_login_user

  It stores an updated connection and a registered user in the
  test context.
  """
  def register_and_login_api_user(%{conn: conn}) do
    user = TodoList.AccountsFixtures.user_fixture()
    %{conn: login_api_user(conn, user), user: user}
  end

  @doc """
  Logs the given `user` into the `conn`.

  It returns an updated `conn`.
  """
  def login_user(conn, user) do
    token = TodoList.Accounts.generate_user_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end

  @doc """
  Simulate a logged-in user by adding a valid 'authorization' header.

  It returns an updated `conn`.
  """
  def login_api_user(conn, user) do
    # login user and set them as current_user
    conn = login_user(conn, user) |> Plug.Conn.assign(:current_user, user)

    # add auth header to request
    token = TodoList.Accounts.generate_user_session_token(user) |> Base.url_encode64()
    conn = Plug.Conn.put_req_header(conn, "authorization", "Bearer #{token}")

    conn
  end

  @doc """
  Logs the user out.

  It returns an updated conn.
  """
  def logout_user(conn) do
    conn |> TodoListWeb.UserAuth.logout_user() |> Phoenix.ConnTest.recycle()
  end

  @doc """
  Simulate a logged-out user by:
    - Removing the 'authorization' header
    - Dropping the `current_user` key from `conn.assigns`

  It returns an updated conn.
  """
  def logout_api_user(conn) do
    # remove :current_user from conn.assigns
    conn = update_in(conn.assigns, &Map.drop(&1, [:current_user]))

    # remove auth header
    conn |> Plug.Conn.delete_req_header("authorization")
  end

  @doc "Create new user and add auth header."
  def setup_authenticate_api_user(context) do
    conn = register_and_login_api_user(%{conn: context.conn}) |> Map.get(:conn)

    %{conn: conn}
  end
end