defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Repo
  alias Discuss.Topics

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    IO.inspect(conn.assigns.user)
    topics = Repo.all(Topics)
    render conn, "index.html", topics: topics
  end


  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topics, topic_id)
    render conn, "show.html", topic: topic
  end

  def new(conn, _params) do

    changeset = Topics.changeset(%Topics{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topics" => topic}) do
    changeset = conn.assigns.user
    |> Ecto.build_assoc(:topics)
    |> Topics.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Topic Creation Failed")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topics, topic_id)
    changeset = Topics.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topics" => topic}) do
    old_topic = Repo.get(Topics, topic_id)
    changeset = Topics.changeset(old_topic, topic)
    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Topic Update Failed")
        |> render("edit.html", changeset: changeset, topic: old_topic)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topics, topic_id) |> Repo.delete!
    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn
    if Repo.get(Topics, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You are not allowed to edit this topic")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end

  end

end
