use Mix.Config

# no debug messages, in prod
config :logger, level: :info

import_config "prod.secret.exs"
