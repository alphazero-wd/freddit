defmodule FredditWeb.PostControllerTest do
  use FredditWeb.ConnCase, async: true

  import Freddit.{PostsFixtures, AccountsFixtures}

  @create_attrs %{content: "some content", title: "some title"}
  @update_attrs %{content: "some updated content", title: "some updated title"}
  @invalid_attrs %{content: nil, title: nil, category_id: nil}

  setup :register_and_log_in_user

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert html_response(conn, 200) =~ "Latest posts"
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :new))
      assert html_response(conn, 200) =~ "Create new post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      category = category_fixture()

      conn =
        post(conn, Routes.post_path(conn, :create),
          post: Map.put(@create_attrs, :category_id, category.id)
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.post_path(conn, :show, id)

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert html_response(conn, 200) =~ "some title"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create, post: @invalid_attrs))
      assert html_response(conn, 200) =~ "Create new post"
    end

    test "renders errors when category doesn't exist", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.post_path(conn, :create, post: Map.put(@create_attrs, :category_id, 123))
        )

      assert html_response(conn, 200) =~ "Create new post"
    end
  end

  describe "edit post" do
    test "renders form for editing chosen post", %{conn: conn, user: user} do
      post = post_fixture(user)
      conn = get(conn, Routes.post_path(conn, :edit, post))
      assert html_response(conn, 200) =~ "Edit post"
    end

    test "doesn't render form when the current user doesn't own the post", %{conn: conn} do
      post = post_fixture(user_fixture())

      assert_error_sent(404, fn ->
        get(conn, Routes.post_path(conn, :edit, post))
      end)
    end
  end

  describe "update post" do
    test "redirects when data is valid", %{conn: conn, user: user} do
      post = post_fixture(user)
      conn = put(conn, Routes.post_path(conn, :update, post), post: @update_attrs)
      assert redirected_to(conn) == Routes.post_path(conn, :show, post)

      conn = get(conn, Routes.post_path(conn, :show, post))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when the user doesn't own the post", %{conn: conn} do
      post = post_fixture(user_fixture())

      assert_error_sent(:not_found, fn ->
        put(conn, Routes.post_path(conn, :update, post), post: @update_attrs)
      end)

      conn = get(conn, Routes.post_path(conn, :show, post))
      refute html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      post = post_fixture(user)
      conn = put(conn, Routes.post_path(conn, :update, post), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit post"
    end

    test "renders errors when category doesn't exist", %{conn: conn, user: user} do
      post = post_fixture(user)

      conn =
        put(
          conn,
          Routes.post_path(conn, :update, post),
          post: Map.put(@update_attrs, :category_id, 123)
        )

      assert html_response(conn, 200) =~ "Edit post"
    end
  end

  describe "delete post" do
    test "deletes chosen post", %{conn: conn, user: user} do
      post = post_fixture(user)
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert redirected_to(conn) == Routes.post_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, Routes.post_path(conn, :show, post))
      end)
    end

    test "doesn't delete post if the user doesn't own it", %{conn: conn} do
      post = post_fixture(user_fixture())

      assert_error_sent(:not_found, fn ->
        delete(conn, Routes.post_path(conn, :delete, post))
      end)
    end
  end
end
