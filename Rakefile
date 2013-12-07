$:.unshift File.dirname(__FILE__)
require 'main'

namespace "run" do
  task :create do
    sync = Synchronizer.new
    sync.create_all
  end

  task :init do
    sync = Synchronizer.new
    sync.init_all
  end

  task :sync do
    sync = Synchronizer.new
    sync.sync_all
  end
end

