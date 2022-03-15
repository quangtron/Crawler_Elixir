use Mix.Config

config :crawly,
  pipelines: [
    Crawly.Pipelines.JSONEncoder, # encode each item into json
    {Crawly.Pipelines.WriteToFile, folder: "priv/output/", extension: "json"} # stores the items into a file inside the folder specified
  ]
