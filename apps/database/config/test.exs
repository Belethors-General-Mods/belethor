use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :database, Database.Repo,
  username: "postgres",
  password: "postgres",
  database: "belethor_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :database,
  test_time: 1000,
  test_runs: 10_000
