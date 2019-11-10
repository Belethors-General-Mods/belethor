defmodule TagEditorWeb.Router do
  use TagEditorWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", TagEditorWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/modlist", TagEditorWeb do
    pipe_through :browser

    # all html sites
    get "/", ModListController, :all
    # view a list of all modlists
    get "/:id", ModListController, :view
    # view a list of mods of one modlist
    get "/:id/new", ModListController, :new
    # view a form to create a new modlist

    # form actions
    post "/:id", ModListController, :create
    put "/:id", ModListController, :update
    delete "/:id", ModListController, :delete
  end

  scope "/mod", TagEditorWeb do
    pipe_through :browser

    ## all html sites
    # view a list of all modlists
    get "/", ModController, :all
    # view a form to create a new modlist
    get "/new", ModController, :new
    # view a list of mods of one modlist
    get "/:id", ModController, :view

    ## form actions
    post "/new", ModController, :create
    put "/:id", ModController, :update
    delete "/:id", ModController, :delete
  end
end
