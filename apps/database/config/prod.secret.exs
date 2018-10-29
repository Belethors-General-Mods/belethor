use Mix.Config

config :website, Database.Repo,
  username: "postgres",
  password: "postgres",
  database: "belethor",
  hostname: "localhost",
  pool_size: 10
