# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :website, WebsiteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Mt2tj+6BdZ16NAwrL2q4DFlKz8ICpLg36zLTzTivXrDGiZplMNZ3wCUdSWOJBA8+",
  render_errors: [view: WebsiteWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Website.PubSub, adapter: Phoenix.PubSub.PG2]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
