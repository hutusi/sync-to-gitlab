
require 'net/http'
require 'json'


class Project
  def initialize
    @base_url = 'http://gitlab.local/api/v3'
    @private_token = 'gyhzxARwhpt23Y8Qogbg'
    @sudo = 'hutusi'
  end

  def projects_url
    url "projects"
  end

  def groups_url
    url "groups"
  end

  def url(section)
    "#{@base_url}/#{section}?private_token=#{@private_token}"
  end

  def query(url)
    resp = Net::HTTP.get_response(URI.parse(url))
    resp.body
  end

  def list
    url = URI("http://gitlab.local/api/v3/projects?private_token=gyhzxARwhpt23Y8Qogbg")
    resp = Net::HTTP.get_response(URI.parse(url))
    
    resp_text = resp.body
    p resp_text 
  end

  def create(project_name)
    url = URI("http://gitlab.local/api/v3/projects?private_token=gyhzxARwhpt23Y8Qogbg")
    params = {
      "name" => project_name,
      "description" => '',
      "issues_enabled" => false,
      "wall_enabled" => false,
      "merge_requests_enabled" => false,
      "wiki_enabled" => false,
      "snippets_enabled" => false,
      "public" => true
    }

    resp = Net::HTTP.post_form(url, params)
  end
  
  def create_project_for_group(group_id, project_name)
    url = "#{projects_url}&namespace_id=#{group_id}"
    p url
    params = {
      "name" => project_name,
      "description" => '',
      "issues_enabled" => false,
      "wall_enabled" => false,
      "merge_requests_enabled" => false,
      "wiki_enabled" => false,
      "snippets_enabled" => false,
      "public" => true
    }

    resp = Net::HTTP.post_form(URI.parse(url), params)
  end

  def get_group_id(group_name)
    groups = get_groups
    groups.each {|x|
      return x["id"] if x["name"] == group_name
    }
    nil
  end

  def get_groups
    resp = query groups_url
    JSON.parse resp
  end
end

prj = Project.new
id = prj.get_group_id("test")
prj.create_project_for_group(id, "my_test")
