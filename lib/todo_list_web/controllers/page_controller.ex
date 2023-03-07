defmodule TodoListWeb.PageController do
  use TodoListWeb, :controller

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
