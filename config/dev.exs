import Config

config :error_demo, ErrorDemo.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "error_demo_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
