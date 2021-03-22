defmodule Discuss.AddComments do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:content, :user]}

  schema "comments" do
    field :content, :string
    belongs_to :user , Discuss.User
    belongs_to :topics, Discuss.Topics

    timestamps()
  end

  @doc false
  def changeset(add_comments, attrs) do
    add_comments
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
