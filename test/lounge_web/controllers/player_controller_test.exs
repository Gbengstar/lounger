defmodule LoungeWeb.PlayerControllerTest do
  use LoungeWeb.ConnCase

  import Lounge.PlayersFixtures

  alias Lounge.Players.Player

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
    test "lists all players", %{conn: conn} do
      conn = get(conn, ~p"/api/players")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create player" do
    test "renders player when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/players", player: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/players/#{id}")

      assert %{
               "id" => ^id,
               "address" => "some address",
               "age" => 42,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/players", player: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update player" do
    setup [:create_player]

    test "renders player when data is valid", %{conn: conn, player: %Player{id: id} = player} do
      conn = put(conn, ~p"/api/players/#{player}", player: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/players/#{id}")

      assert %{
               "id" => ^id,
               "address" => "some updated address",
               "age" => 43,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, player: player} do
      conn = put(conn, ~p"/api/players/#{player}", player: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete player" do
    setup [:create_player]

    test "deletes chosen player", %{conn: conn, player: player} do
      conn = delete(conn, ~p"/api/players/#{player}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/players/#{player}")
      end
    end
  end

  defp create_player(_) do
    player = player_fixture()
    %{player: player}
  end
end
