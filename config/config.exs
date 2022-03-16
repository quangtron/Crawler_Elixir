use Mix.Config

config :crawly,
  pipelines: [
    Crawly.Pipelines.JSONEncoder, # encode each item into json
  ]
