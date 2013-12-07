
require 'net/http'
require 'json'


class Project
  def initialize(config)
    @config = config
    @params = config["params"]
    @base_url = @config["base_url"]
    @private_token = @config["private_token"]
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
  
  def create_project_for_group(group_id, name, desc = "")
    url = "#{projects_url}&namespace_id=#{group_id}"
    @params["name"] = name
    @params["description"] = desc
    p @params
    resp = Net::HTTP.post_form(URI.parse(url), @params)
    p resp 
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

