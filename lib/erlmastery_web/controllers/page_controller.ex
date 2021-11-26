defmodule ErlmasteryWeb.PageController do
  use ErlmasteryWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
