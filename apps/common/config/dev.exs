use Mix.Config

# Configure your database
config :common, Common.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "belethor_dev",
  hostname: "localhost",
  pool_size: 10
