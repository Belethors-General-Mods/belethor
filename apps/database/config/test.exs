use Mix.Config

# Configure your database
config :website, Database.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "belethor_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
