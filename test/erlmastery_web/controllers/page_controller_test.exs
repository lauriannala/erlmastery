defmodule ErlmasteryWeb.PageControllerTest do
  use ErlmasteryWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Lauri Annala"
  end
end
