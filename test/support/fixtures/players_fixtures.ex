defmodule Lounge.PlayersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lounge.Players` context.
  """

  @doc """
  Generate a player.
  """
  def player_fixture(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
        address: "some address",
        age: 42,
        name: "some name"
      })
      |> Lounge.Players.create_player()

    player
  end
end
