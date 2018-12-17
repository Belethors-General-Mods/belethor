# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :tag_editor, TagEditorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yC8vstJhHHMhSQ6LkddYqmkFCxhKuFWdI4MaCtHdQYkVQVm3xTPmsEkI4yCTFWP1",
  render_errors: [view: TagEditorWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TagEditor.PubSub, adapter: Phoenix.PubSub.PG2]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
