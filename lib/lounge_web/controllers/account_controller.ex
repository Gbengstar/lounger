defmodule LoungeWeb.AccountController do
  use LoungeWeb, :controller

  alias Lounge.Accounts
  alias Lounge.Accounts.Account

  action_fallback LoungeWeb.FallbackController

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, token, _full_claims} <- Lounge.Guardian.encode_and_sign(account) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/accounts/#{account}")
      |> render(:create, account: account, token: token)
    end
  end

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, account, token} <- Lounge.Guardian.authenticate(email, password) do
      conn
      |> put_status(:ok)
      |> render(:create, account: account, token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, :show, account: account)
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      render(conn, :show, account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
