
require 'repository'
require 'json'

config = JSON.parse(File.read("config.json"))
workspace = config["workspace"]
init_repos = config["init"]


