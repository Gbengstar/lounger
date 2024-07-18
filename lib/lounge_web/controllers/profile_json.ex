defmodule LoungeWeb.ProfileJSON do
  alias Lounge.Profiles.Profile

  @doc """
  Renders a list of profiles.
  """
  def index(%{profiles: profiles}) do
    %{data: for(profile <- profiles, do: data(profile))}
  end

  @doc """
  Renders a single profile.
  """
  def show(%{profile: profile}) do
    %{data: data(profile)}
  end

  defp data(%Profile{} = profile) do
    %{
      id: profile.id,
      name: profile.name,
      age: profile.age,
      address: profile.address
    }
  end
end
