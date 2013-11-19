
require 'net/http'

url = "http://gitlab.local/api/v3/projects?private_token=gyhzxARwhpt23Y8Qogbg"
resp = Net::HTTP.get_response(URI.parse(url))

resp_text = resp.body
p resp_text 

