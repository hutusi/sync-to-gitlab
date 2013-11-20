
class Repository
  def initialize(path, src_url, dest_url)
    @path = path
    @src_url = src_url
    @dest_url = dest_url
  end

  def init
    `git clone --bare #{@src_url} #{@path}`
    Dir.chdir(@path){
      `git remote add gitlab #{@dest_url}`
    }
  end

  def sync
    Dir.chdir(@path){
      `git fetch origin`
      `git push --mirror gitlab`
    }
  end
end

repo = Repository.new("/Users/john/workspace/my_github/test/vim", "https://github.com/hutusi/vimfiles", "git@gitlab.local:hutusi/vim.git")
repo.init
repo.sync