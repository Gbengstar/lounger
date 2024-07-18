defmodule Lounge.Profiles.Profile do
  alias Lounge.Accounts.Account
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :name, :string
    field :address, :string
    field :age, :integer
    belongs_to :accounts, Account

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name, :age, :address, :accounts_id])
    |> validate_required([:name, :age, :address, :accounts_id])
    |> unique_constraint(:accounts_id)
  end
end
