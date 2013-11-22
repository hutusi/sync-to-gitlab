require 'logger'
require 'date'

module Logging
  def get_log_file
    Date.today.to_s + ".log"
  end

  def logger
    @@logger ||= Logger.new(get_log_file)
  end
end

