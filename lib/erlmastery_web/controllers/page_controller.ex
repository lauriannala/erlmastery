defmodule ErlmasteryWeb.PageController do
  use ErlmasteryWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def portfolio(conn, _params) do
    render(conn, "portfolio.html")
  end
end
