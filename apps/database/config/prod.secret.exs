use Mix.Config

config :website, Database.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "belethor",
  hostname: "localhost",
  pool_size: 10
