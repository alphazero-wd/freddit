defmodule FredditWeb.PageControllerTest do
  use FredditWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Latest posts"
  end
end
