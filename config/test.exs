import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :window_game, WindowGameWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "g5JDzvPPPqNE7DVvm46fAsl45wFo5yonrieCh00oJjEK50NNc4lk6JjCS/fQOArv",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
