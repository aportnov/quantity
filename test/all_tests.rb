require "test_helper"

#Dir.chdir("../")

unit_tests = Dir["test/unit/*test.rb"]
unit_tests.each{|test|
 require test
}