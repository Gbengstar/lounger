defmodule Lounge.ProfilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lounge.Profiles` context.
  """

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        address: "some address",
        age: 42,
        name: "some name"
      })
      |> Lounge.Profiles.create_profile()

    profile
  end
end
