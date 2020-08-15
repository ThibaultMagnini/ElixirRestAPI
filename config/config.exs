# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :projectip,
  ecto_repos: [Projectip.Repo]

config :projectip_web,
  ecto_repos: [Projectip.Repo],
  generators: [context_app: :projectip]

# Configures the endpoint
config :projectip_web, ProjectipWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "axV/LlgD4wymSnOBGEGSuxwqJSeUVxMxrCA3PKQ4B3JiX9d1OLrGt9De/0Jp5CFv",
  render_errors: [view: ProjectipWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ProjectipWeb.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "kf0mtRpq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :projectip_web, ProjectipWeb.Guardian,
  issuer: "projectip_web",
  secret_key: "5ClKHllRIZCmXlbjZVlflwHEjc8ubiL3Nd4OvqJp+kemvogyzv11KaOWAmAORohP"

config :projectip, Projectip.GetText,
  locales: ~w(en nl),
  default_locale: "en"
