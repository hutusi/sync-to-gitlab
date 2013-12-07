$:.unshift File.dirname(__FILE__)
require 'main'

namespace "run" do
  task :create do
    sync = Synchronizer.new
    sync.create_all
  end

  task :init do
    init_all
  end

  task :sync do
    sync_all
  end
end

