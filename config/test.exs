use Mix.Config

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configures Elixir's Logger
config :logger, :console,
  level: :debug,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :ex_unit, capture_log: true

# this is not a part of ex_unit; that name is just used so the compiler shuts up
config :ex_unit, :test_timings,
  max_run_time: 500,
  max_runs: 1_000_000_000
