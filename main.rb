
require 'project'
require 'repository'
require 'json'

class Synchronizer
  def initialize
    parse
    @project = Project.new
  end

  def parse
    @config = {}
    @config["github"] = "http://github.com/"
    @config["gitlab"] = "git@gitlab.local:"
    projects_config = JSON.parse(File.read("projects.json"))
    @workspaces = parse_workspaces projects_config
  end

  def create_all
    @workspaces.each {|w|
      group_id = @project.get_group_id w["group"]
      w["projects"].each {|p|
        @project.create_project_for_group group_id, p["name"]
      }
    }
  end

  def init_all
    @workspaces.each {|w|
      w["projects"].each {|p|
        repo = Repository.new(p["local"], p["github"], p["gitlab"])
        repo.init
      }
    }
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
          prj["local"] = File.join(ws["dir"], name + ".git")
          projects << prj
        }
        ws["projects"] = projects
        workspaces << ws
      }
      workspaces
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

