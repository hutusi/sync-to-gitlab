
require 'repository'
require 'json'

def parse_config
  JSON.parse(File.read("config.json"))
end

def init_all
  config = parse_config
  workspace = config["workspace"]
  repos = config["init"]

  repos.each { |x|
    path = File.join(workspace, x["name"] + ".git")
    repo = Repository.new(path, x["src_url"], x["dest_url"])
    repo.init
  }
end

def sync_all
  config = parse_config
  workspace = config["workspace"]

  path = File.join(workspace, "*.git")
  Dir.glob(path) { |x|
    repo = Repository.new(path)
    repo.sync
  }
end

