
class Repository
  def initialize(path, src_url="", dest_url="")
    @path = path
    @src_url = src_url
    @dest_url = dest_url
  end

  def init
    begin
      `git clone --mirror #{@src_url} #{@path}`
      Dir.chdir(@path){
        `git remote add gitlab #{@dest_url}`
      }
    rescue Exception => ex
      p ex
    end
  end

  def sync
    begin
      Dir.chdir(@path){
        `git fetch origin`
        `git push --all gitlab`
      }
    rescue Exception => ex
      p ex
    end
  end
end

