
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
    @workspaces.each {|w|
      w["projects"].each {|p|
        repo = Repository.new(p["local"], p["github"], p["gitlab"])
        repo.sync
      }
    }
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

