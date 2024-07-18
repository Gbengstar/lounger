defmodule LoungeWeb.ProfileController do
  use LoungeWeb, :controller

  alias Lounge.Profiles
  alias Lounge.Profiles.Profile

  action_fallback LoungeWeb.FallbackController

  def index(conn, _params) do
    accounts_id = conn.private[:guardian_default_resource].id
    profile = Profiles.get_profile_by_account_id!(accounts_id)
    render(conn, :show, profile: profile)
  end

  def create(conn, %{"profile" => profile_params}) do
    # %{:guardian_default_resource => guardian_resource} = conn
    IO.puts(conn.private[:guardian_default_resource].id)

    accounts_id = conn.private[:guardian_default_resource].id

    profile_params = Map.put(profile_params, "accounts_id", accounts_id)

    with {:ok, %Profile{} = profile} <-
           Profiles.create_profile(profile_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", ~p"/api/profiles/#{profile}")
      |> render(:show, profile: profile)
    end
  end

  def show(conn, %{"id" => id}) do
    profile = Profiles.get_profile!(id)
    render(conn, :show, profile: profile)
  end

  def update(conn, %{ "profile" => profile_params}) do
    accounts_id = conn.private[:guardian_default_resource].id
    profile = Profiles.get_profile_by_account_id!(accounts_id)

    with {:ok, %Profile{} = profile} <- Profiles.update_profile(profile, profile_params) do
      render(conn, :show, profile: profile)
    end
  end

  def delete(conn, %{"id" => id}) do
    profile = Profiles.get_profile!(id)

    with {:ok, %Profile{}} <- Profiles.delete_profile(profile) do
      send_resp(conn, :no_content, "")
    end
  end
end
