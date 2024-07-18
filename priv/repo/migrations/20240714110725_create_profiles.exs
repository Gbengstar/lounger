defmodule Lounge.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :name, :string
      add :age, :integer
      add :address, :string
      add :accounts_id, references(:accounts)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:profiles, [:accounts_id])
  end
end
