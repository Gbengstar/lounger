defmodule Lounge.Players.Player do
  alias Lounge.Accounts.Account
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :name, :string
    field :address, :string
    field :age, :integer
    belongs_to :account, Account

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :age, :address, :accounts_id])
    |> validate_required([:name, :age, :address, :accounts_id])
    |> unique_constraint(:accounts_id)
  end
end
