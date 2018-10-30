use Mix.Config

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :database, Database.Repo,
  username: "postgres",
  password: "postgres",
  database: "belethor_dev",
  hostname: "localhost",
  pool_size: 10

config :database,
  test_time: 100,
  test_runs: 1000
