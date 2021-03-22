defmodule DiscussWeb.CommentsChannel do
  alias Discuss.Repo
  alias Discuss.{Topics, AddComments}
  use DiscussWeb, :channel

  @impl true
  def join("comments:" <> topic_id, _payload, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topics
      |>Repo.get(topic_id)
      |>Repo.preload(comments: [:user])
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end


  @impl true
  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id
    IO.inspect(user_id)
    changeset = topic
    |> Ecto.build_assoc(:comments, user_id: user_id)
    |> AddComments.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new",
          %{comment: Repo.preload(comment, :user)}
          )
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

end
