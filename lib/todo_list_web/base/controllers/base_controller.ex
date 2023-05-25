defmodule TodoListWeb.BaseController do
  use TodoListWeb, :controller

  def debug(conn, params) do
    # use query params for testing/debugging backend features
    cond do
      params["sentry_error"] == "1" ->
        # generate and send an example error to sentry
        try do
          raise RuntimeError, message: "Example Error for Sentry"
        rescue
          err ->
            Sentry.capture_exception(err,
              stacktrace: __STACKTRACE__,
              extra: %{extra_info: "Extra information"}
            )
        end

        # return 404 after sending error to sentry
        conn |> TodoListWeb.Helpers.Controller.http_response_404()

      params["error"] == "403" ->
        conn |> TodoListWeb.Helpers.Controller.http_response_403()

      params["error"] == "404" ->
        conn |> TodoListWeb.Helpers.Controller.http_response_404()

      params["error"] == "500" ->
        raise RuntimeError, message: "Example Error"

      true ->
        # return 404 by default
        conn |> TodoListWeb.Helpers.Controller.http_response_404()
    end
  end

  def contact_us(conn, _params) do
    render(conn, :contact_us, page_title: "Contact Us")
  end

  def privacy_policy(conn, _params) do
    render(conn, :privacy_policy, page_title: "Privacy Policy")
  end

  def terms_of_use(conn, _params) do
    render(conn, :terms_of_use, page_title: "Terms of Use")
  end
end
