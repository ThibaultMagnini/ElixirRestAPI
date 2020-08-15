defmodule ProjectipWeb.Router do

  use ProjectipWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ProjectipWeb.Plugs.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ProjectipWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :allowed_for_users do
    plug ProjectipWeb.Plugs.AuthorizationPlug, ["Admin", "User"]
  end

  pipeline :allowed_for_admins do
    plug ProjectipWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  scope "/", ProjectipWeb do
    pipe_through [:browser, :auth]

    get "/", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
    get "/register", UserController, :register
    post "/register", UserController, :create_register
  end

  scope "/", ProjectipWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]
    get "/user_scope", PageController, :user_index
  end

  scope "/admin", ProjectipWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]
    resources "/users", UserController
  end

  scope "/profile", ProjectipWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]
    get "/", UserController, :profile
    get "/edit", UserController, :editprofile
    post "/edit", UserController, :editusername
    get "/changepassword", UserController, :changepassword
    post "/changepassword", UserController, :updatepassword
    post "/", UserController, :generateapikey
    get "/showkey/:api_id", UserController, :showkey
    delete "/deletekey/:api_id", UserController, :deletekey
  end


  scope "/api", ProjectipWeb do
    pipe_through :api

    resources "/users", UserController, only: [] do
      resources "/animals", AnimalController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ProjectipWeb do
  #   pipe_through :api
  # end
end
