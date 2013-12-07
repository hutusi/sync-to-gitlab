
class Repository
  def initialize(path, src_url="", dest_url="")
    @path = path
    @src_url = src_url
    @dest_url = dest_url
  end

  def init
    begin
      p `git clone --mirror #{@src_url} "#{@path}"`
      Dir.chdir(@path){
        p `git remote add gitlab #{@dest_url}`
      }
    rescue Exception => ex
      p ex
    end
  end

  def sync
    begin
      Dir.chdir(@path){
        p `git fetch origin`
        p `git push --all gitlab`
      }
    rescue Exception => ex
      p ex
    end
  end
end

