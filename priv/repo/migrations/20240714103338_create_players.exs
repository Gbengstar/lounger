defmodule Lounge.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :age, :integer
      add :address, :string
      add :accounts_id, references(:accounts)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:players, [:accounts_id])
  end
end
