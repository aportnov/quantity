require 'test/unit'
require 'logger'

require File.dirname(__FILE__) + '/../lib/quantity'

class Test::Unit::TestCase
  # Add more helper methods to be used by all tests here...
  
  def logger
    unless @log
      @log = Logger.new(STDOUT)
      @log.level = Logger::DEBUG
      @log.datetime_format = '%a %b %d %H:%M:%S %Z %Y'
    end
    
    @log
  end
end