defmodule KaifaLiWeb.Router do
  use KaifaLiWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :authorize do
    plug(BasicAuth, Application.get_env(:kaifa_li, :admin_basic_auth))
  end

  scope "/", KaifaLiWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)

    get("/services/:keyword", ServiceController, :show)
  end

  scope "/admin", as: :admin do
    pipe_through(:browser)
    pipe_through(:authorize)

    resources("/documents", KaifaLiWeb.Admin.DocumentController)
  end

  # Other scopes may use custom stacks.
  scope "/api", as: :api do
    pipe_through(:api)

    get("/services/:keyword", KaifaLiWeb.API.ServiceController, :show)
  end
end
