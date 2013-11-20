
require 'net/http'


class Project
  def list
    url = "http://gitlab.local/api/v3/projects?private_token=gyhzxARwhpt23Y8Qogbg"
    resp = Net::HTTP.get_response(URI.parse(url))
    
    resp_text = resp.body
    p resp_text 
  end

  def create(project_name)
    url = "http://gitlab.local/api/v3/projects?private_token=gyhzxARwhpt23Y8Qogbg"
    params = {
      :name => project_name,
      :description => '',
      :issues_enabled => false,
      :wall_enabled => false,
      :merge_requests_enabled => false,
      :wiki_enabled => false,
      :snippets_enabled => false,
      :public => true
    }

    resp = Net::HTTP.post_form(url, params)
  end
end

prj = Project.new
prj.create "for_test"

