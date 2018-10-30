use Mix.Config

# Configure your database
config :website, Database.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "belethor_dev",
  hostname: "localhost",
  pool_size: 10
