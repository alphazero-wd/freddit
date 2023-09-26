defmodule FredditWeb.PostController do
  use FredditWeb, :controller
  alias Freddit.{Posts, Categories, Posts.Post}

  plug(:load_categories when action in [:index, :category, :new, :create, :edit, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  defp load_categories(conn, _) do
    categories = Categories.load_categories()
    assign(conn, :categories, categories)
  end

  def index(conn, params, _user) do
    page = Posts.list_posts(params)

    render(conn, "index.html",
      page_title: "Latest posts",
      posts: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    )
  end

  def category(conn, %{"category" => category_id}, _user) do
    {posts, category} = Posts.get_posts_by_category(category_id)

    render(conn, "category.html", page_title: category.name, posts: posts, category: category)
  end

  def new(conn, _params, _user) do
    changeset = Posts.change_post(%Post{})
    render(conn, "new.html", page_title: "Create a post", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}, user) do
    case Posts.create_post(post_params, user) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, changeset} ->
        render(conn, "new.html", page_title: "Create a post", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _user) do
    post = Posts.get_post!(id)
    render(conn, "show.html", page_title: post.title, post: post)
  end

  def edit(conn, %{"id" => id}, user) do
    post = Posts.get_post_by_owner(user, id)
    changeset = Posts.change_post(post)

    render(conn, "edit.html",
      page_title: "Edit post: " <> post.title,
      post: post,
      changeset: changeset
    )
  end

  def update(conn, %{"id" => id, "post" => post_params}, user) do
    post = Posts.get_post_by_owner(user, id)

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          page_title: "Edit post: " <> post.title,
          post: post,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}, user) do
    post = Posts.get_post_by_owner(user, id)
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
