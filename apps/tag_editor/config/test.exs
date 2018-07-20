use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tag_editor, TagEditorWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :tag_editor, TagEditor.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "tag_editor_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
