defmodule SpenderWeb.AuthController do
  use SpenderWeb, :controller
  plug Ueberauth

  alias Spender.{Accounts, Accounts.User}

  def welcome(conn, _params) do
    text conn, "Welcome to Our Api"
  end

  # handle callback payload
  def new(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, first_name: auth.info.first_name, last_name: auth.info.last_name, email: auth.info.email, provider: "google"}
    _changeset = User.changeset(%User{}, user_params)

    create(conn, user_params)
  end

  # if we can pick a user lets proceed to sign them in and add their details to the session
  def create(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Thank you for signing in!")
        |> Guardian.Plug.sign_in(user) #Load session with  user payload
        |> text("Thank You for signing in!")
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> text("Error signing in")
    end
  end

  # function to sign user
  def logout(conn, _) do
    conn
    |> Guardian.plug.sign_out()
    |> redirect(to: "/")
  end



  defp insert_or_update_user(%{email: email}=changeset) do
    case Accounts.get_by_email(email) do
      nil ->
        Accounts.create_user(changeset)
      user ->
        {:ok, user}
    end
  end
end
