dir = File.dirname(__FILE__)

require dir + "/test_helper"

unit_tests = Dir[dir + "/../test/*test.rb"]
unit_tests.each{|test|
 require test
}