require File.dirname(__FILE__) + '/test_helper'

include Unit
include Quantity

class ConfigurationTest < Test::Unit::TestCase

  def setup
    #Sinse now we can add units tocalculator, lets try it here...
    @config = Configuration.new
    
    @config.unit :unit => :mm 
    @config.unit :unit => :cm, :based_on => :mm, :coefficient => 10
    @config.unit :unit => :m, :based_on => :cm, :coefficient => 100

    @config.unit :unit => :g
    @config.unit :unit => :kg, :based_on => :g, :coefficient => 1000.0
    @config.unit :unit => :oz, :based_on => :g, :coefficient => 28.349523125
    @config.unit :unit => :lb, :based_on => :oz, :coefficient => 16
    @config.unit :unit => :mg, :based_on => :g, :coefficient => 0.001

    @config.unit :unit => :sec
  end


  def test_create_calculator
    
    calc = @config.calc
    
    assert_not_nil calc
    assert_nothing_raised(RuntimeError){ calc.add_conversion 1.m => 10.lb }
    assert_equal(0, @config.calc.conversions.length)    
    assert_nothing_raised(RuntimeError){@config.conversion 1.m => 5.lb}
    
    qty = calc.exp(:lb){1.m}
    assert_in_delta(10.0, qty.value, 0.0001)
  end
  
  def test_block_initialization
    
    config = Configuration.new(){|conf|
      conf.unit :unit => :mm 
      conf.unit :unit => :cm, :based_on => :mm, :coefficient => 10
      conf.unit :unit => :m, :based_on => :cm, :coefficient => 100
  
      conf.unit :unit => :g
      conf.unit :unit => :oz, :based_on => :g, :coefficient => 28.349523125
      conf.unit :unit => :lb, :based_on => :oz, :coefficient => 16
    
      conf.conversion 1.m => 5.lb  
     
    }
  
    calc = config.calc

    qty = calc.exp(:lb){1.m}
    assert_in_delta(5.0, qty.value, 0.0001)
  end

  def test_default_configuration
    assert_not_nil($configuration)
    
    calc = $configuration.calc
    
    qty = calc.exp(:m){20.cm + 600.mm}
    
    assert_in_delta(0.8, qty.value, 0.0001)
  end

end