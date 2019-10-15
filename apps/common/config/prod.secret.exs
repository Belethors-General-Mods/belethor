use Mix.Config

config :common, Common.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "belethor",
  hostname: "localhost",
  pool_size: 10
