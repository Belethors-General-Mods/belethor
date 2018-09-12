use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :website, Database.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "belethor_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
