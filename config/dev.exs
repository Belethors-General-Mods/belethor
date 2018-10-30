use Mix.Config

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configures Elixir's Logger
config :logger, :console,
  level: :info,
  format: "$time $metadata [$level] $message\n",
  metadata: [:user_id]
