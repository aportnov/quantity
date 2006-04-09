require File.dirname(__FILE__) + '/../test_helper'

class SpecParserTest < Test::Unit::TestCase
  
  include Unit

  def setup

    @units = {}
    @units[:mm] = SimpleUnit.new(:unit => :mm)
    @units[:cm] = SimpleUnit.new(:unit => :cm, :based_on => @units[:mm], :coefficient => 10)  
    @units[:m] = SimpleUnit.new(:unit => :m, :based_on => @units[:cm], :coefficient => 100)
    @units[:g] = SimpleUnit.new(:unit => :g)
    @units[:kg] = SimpleUnit.new(:unit => :kg, :based_on => @units[:g], :coefficient => 1000.0)
  
  end

  
  def test_parse_unit_spec
    
    parser = Parser.new(@units)
    
    assert_nothing_raised(RuntimeError) {

      result = parser.to_units("mm*g/cm*kg")
      assert_equal([@units[:mm], @units[:g]], result[:dividends])    
      assert_equal([@units[:cm], @units[:kg]], result[:divisors])    
    }
    
    assert_raise(RuntimeError){ parser.to_units("mm*lb/cm*kg")}
  end

  def test_name_parsing
    name = "mm*lb/cm*kg"
  
    parts = name.split(/\//)
    
    assert_equal(2, parts.size)
    assert_equal("mm*lb", parts[0])
    assert_equal("cm*kg", parts[1])
    
    name = "mm*lb"
    
    parts = name.split(/\//)

    assert_not_nil parts[0]    
    assert_nil parts[1]
  end

end
