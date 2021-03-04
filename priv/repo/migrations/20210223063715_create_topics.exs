defmodule Discuss.Repo.Migrations.CreateTopics do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :tittle, :string

      timestamps()
    end

  end
end
