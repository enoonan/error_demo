import Config

config :logger, level: :warning
config :ash, disable_async?: true

config :error_demo, ErrorDemo.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "error_demo_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
