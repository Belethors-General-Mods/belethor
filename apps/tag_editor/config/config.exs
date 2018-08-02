# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :tag_editor,
  namespace: TagEditor,
  ecto_repos: [TagEditor.Repo]

# Configures the endpoint
config :tag_editor, TagEditorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uxxxziQwE11eNSm9+J/rT4PKyQsKMHQ/ab0ZAqsjLuxLWd98aAw8baQKO6+sGbNy",
  render_errors: [view: TagEditorWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TagEditor.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
