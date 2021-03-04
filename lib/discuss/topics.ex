defmodule Discuss.Topics do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :tittle, :string

    timestamps()
  end

  @doc false
  def changeset(topics, attrs \\ %{}) do
    topics
    |> cast(attrs, [:tittle])
    |> validate_required([:tittle])
  end
end
