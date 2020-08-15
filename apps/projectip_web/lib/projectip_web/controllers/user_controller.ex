defmodule ProjectipWeb.UserController do
  use ProjectipWeb, :controller

  alias Projectip.UserContext
  alias Projectip.UserContext.User
  alias Projectip.ApiKeyContext

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = UserContext.change_user(%User{})
    roles = UserContext.get_acceptable_roles()
    render(conn, "new.html", changeset: changeset, acceptable_roles: roles)
  end

  def create(conn, %{"user" => user_params}) do
    case UserContext.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("User created successfully."))
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    changeset = UserContext.change_user(user)
    roles = UserContext.get_acceptable_roles()
    render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)

    case UserContext.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("User updated successfully."))
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    {:ok, _user} = UserContext.delete_user(user)

    conn
    |> put_flash(:info, gettext("User deleted successfully."))
    |> redirect(to: Routes.user_path(conn, :index))
  end

  def register(conn, _params) do
    changeset = UserContext.change_user(%User{})
    # roles = UserContext.get_acceptable_roles()
    render(conn, "make.html", changeset: changeset)
  end

  def create_register(conn, %{"user" => %{"username" => username, "newPassword" => newPassword, "confirmPassword" => confirmPassword}}) do
    if (newPassword == confirmPassword) do
      user_params = %{"username" => username, "password" => newPassword, "role" => "User"}
      case UserContext.create_user(user_params) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, gettext("User created successfully."))
          |> redirect(to: Routes.session_path(conn, :new))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "make.html", changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, gettext("Passwords not matching."))
      |> redirect(to: Routes.user_path(conn, :register))
    end
  end

  def profile(conn, _params) do
    changeset = UserContext.change_user(%User{})
    user = Guardian.Plug.current_resource(conn)
    userkeys = ApiKeyContext.load_keys(user)
    render(conn, "profile.html", user: userkeys, changeset: changeset)
  end

  def editprofile(conn, _params) do
    changeset = UserContext.change_user(%User{})
    user = Guardian.Plug.current_resource(conn)
    render(conn, "editprofile.html", user: user, changeset: changeset)
  end

  def editusername(conn,  %{"user" => %{"username" => username}}) do
    user = Guardian.Plug.current_resource(conn)
    user_params = %{"username" => username}
    case UserContext.change_username(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, gettext("Username updated successfully."))
        |> redirect(to: Routes.user_path(conn, :profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "editprofile.html", changeset: changeset)
    end
  end

  def changepassword(conn, _params) do
    changeset = UserContext.change_user(%User{})
    user = Guardian.Plug.current_resource(conn)
    render(conn, "changepassword.html", user: user, changeset: changeset)
  end

  def updatepassword(conn, %{"user" => %{"password" => password, "newpassword" => newpassword ,"conpassword" => conpassword}}) do
    user = Guardian.Plug.current_resource(conn)
    user_params = %{"password" => newpassword}

    case UserContext.authenticate_user(user.username, password) do
      {:ok, user} ->
        if (newpassword == conpassword) do
          case UserContext.change_password(user, user_params) do
            {:ok, _user} ->
              conn
              |> put_flash(:info, gettext("Password updated successfully."))
              |> redirect(to: Routes.user_path(conn, :changepassword))

            {:error, %Ecto.Changeset{} = changeset} ->
                render(conn, "changepassword.html", changeset: changeset)
          end
        else
          conn
          |> put_flash(:error, gettext("Passwords not matching"))
          |> redirect(to: Routes.user_path(conn, :changepassword))
        end

      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, gettext("Current Password not correct"))
        |> redirect(to: Routes.user_path(conn, :changepassword))

    end
  end


  def generateapikey(conn, %{ "user" => %{"name" => name}}) do
    user = Guardian.Plug.current_resource(conn)

    api_key_params = %{"key" => random_string(64), "name" => name}

    case ApiKeyContext.create_apikey(api_key_params, user) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, gettext("Generated Api Key!"))
        |> redirect(to: Routes.user_path(conn, :profile))

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, gettext("Api key name may not be empty!"))
        |> redirect(to: Routes.user_path(conn, :profile))
    end
  end

  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end


  def showkey(conn, %{"api_id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    apikey = ApiKeyContext.get_api_key!(id)
    if user.id != apikey.id do
      conn
      |> put_flash(:info, gettext("Cant see other peoples api key!"))
      |> redirect(to: Routes.user_path(conn, :profile))
    end

    key = ApiKeyContext.get_api_key!(id)
    render(conn, "showapikey.html", key: key)
  end

  def deletekey(conn, %{"api_id" => id}) do
    key = ApiKeyContext.get_api_key!(id)

    {:ok, _apikey} = ApiKeyContext.delete_api_key(key)

    conn
    |> put_flash(:info, gettext("Api key deleted successfully."))
    |> redirect(to: Routes.user_path(conn, :profile))
  end

end



