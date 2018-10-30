use Mix.Config

config :database, Database.Repo,
  username: "postgres",
  password: "postgres",
  database: "belethor",
  hostname: "localhost",
  pool_size: 10
