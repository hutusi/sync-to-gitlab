
# require 'repository'
require 'json'

class Synchronizer
  def parse
    @config = {}
    @config["github"] = "http://github.com/"
    @config["gitlab"] = "git@gitlab.local:"
    projects_config = JSON.parse(File.read("projects.json"))
    @workspaces = parse_workspaces projects_config
    p @workspaces
  end

  def create_all
  end

  def init_all
  end

  def sync_all
  end

  private
    def parse_workspaces(config)
      workspaces = []
      config.each {|w|
        ws = {}
        ws["dir"] = w["workspace"]
        group = w["group"]
        ws["group"] = group
        projects = []
        w["projects"].each {|p|
          p.strip!
          name = p.split('/')[1]
          prj = {}
          prj["name"] = name
          prj["github"] = "#{@config["github"]}#{p}.git"
          prj["gitlab"] = "#{@config["gitlab"]}#{group}/#{name}.git"
          projects << prj
        }
        ws["projects"] = projects
        workspaces << ws
      }
      workspaces
    end

    def create
    end
end

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
    repo = Repository.new(x)
    repo.sync
  }
end

sync = Synchronizer.new 
sync.parse
