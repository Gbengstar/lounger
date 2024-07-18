defmodule LoungeWeb.ProfileControllerTest do
  use LoungeWeb.ConnCase

  import Lounge.ProfilesFixtures

  alias Lounge.Profiles.Profile

  @create_attrs %{
    name: "some name",
    address: "some address",
    age: 42
  }
  @update_attrs %{
    name: "some updated name",
    address: "some updated address",
    age: 43
  }
  @invalid_attrs %{name: nil, address: nil, age: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all profiles", %{conn: conn} do
      conn = get(conn, ~p"/api/profiles")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create profile" do
    test "renders profile when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/profiles", profile: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/profiles/#{id}")

      assert %{
               "id" => ^id,
               "address" => "some address",
               "age" => 42,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/profiles", profile: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update profile" do
    setup [:create_profile]

    test "renders profile when data is valid", %{conn: conn, profile: %Profile{id: id} = profile} do
      conn = put(conn, ~p"/api/profiles/#{profile}", profile: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/profiles/#{id}")

      assert %{
               "id" => ^id,
               "address" => "some updated address",
               "age" => 43,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, profile: profile} do
      conn = put(conn, ~p"/api/profiles/#{profile}", profile: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete profile" do
    setup [:create_profile]

    test "deletes chosen profile", %{conn: conn, profile: profile} do
      conn = delete(conn, ~p"/api/profiles/#{profile}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/profiles/#{profile}")
      end
    end
  end

  defp create_profile(_) do
    profile = profile_fixture()
    %{profile: profile}
  end
end
