defmodule ErlmasteryWeb.Router do
  use ErlmasteryWeb, :router

  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ErlmasteryWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :guardian do
    plug ErlmasteryWeb.Authentication.Pipeline
  end

  pipeline :browser_auth do
    plug Guardian.Plug.EnsureAuthenticated,
      otp_app: :erlmastery,
      claims: %{"typ" => "access"},
      error_handler: ErlmasteryWeb.Authentication.ErrorHandler,
      module: ErlmasteryWeb.Authentication
  end

  scope "/", ErlmasteryWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/about", PageController, :about
    get "/portfolio", PageController, :portfolio

    scope "/chat", as: :chat_room do
      live "/new", Live.Chat.NewChatRoom, :new
      live "/:name", Live.Chat.ShowChatRoom, :show
    end
  end

  scope "/auth", ErlmasteryWeb do
    pipe_through [:browser, :guardian]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/dashboard" do
    pipe_through [:browser, :guardian, :browser_auth]
    live_dashboard "/", metrics: ErlmasteryWeb.Telemetry
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
