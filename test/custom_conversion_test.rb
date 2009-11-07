require File.dirname(__FILE__) + '/test_helper'

include Unit
include Quantity

class CustomUnitConversionTest < Test::Unit::TestCase

  def setup
    #Sinse now we can add units tocalculator, lets try it here...
    @calc = Calculator.new
    
    @calc.add_unit :unit => :mm 
    @calc.add_unit :unit => :cm, :based_on => :mm, :coefficient => 10
    @calc.add_unit :unit => :m, :based_on => :cm, :coefficient => 100

    @calc.add_unit :unit => :g
    @calc.add_unit :unit => :kg, :based_on => :g, :coefficient => 1000.0
    @calc.add_unit :unit => :oz, :based_on => :g, :coefficient => 28.349523125
    @calc.add_unit :unit => :lb, :based_on => :oz, :coefficient => 16
    @calc.add_unit :unit => :mg, :based_on => :g, :coefficient => 0.001

    @calc.add_unit :unit => :sec
  end

  def test_add_custom_unit_conversion
    @calc.add_unit :unit => :PA
    @calc.add_unit :unit => :sq_in
  
    @calc.add_conversion 1.PA => 6894.757.lb / 1.sq_in
    assert_equal(2, @calc.conversions.length)

    @calc.add_conversion 1.m => 10.lb
    assert_equal(4, @calc.conversions.length)
  end
  
  def test_add_unknown_unit_conversion

    assert_raise(RuntimeError) { @calc.add_conversion 1.PA => 6894.757.lb / 1.sq_in }
  
  end
  
  def test_conversion_usage
    @calc.add_conversion 1.m => 10.lb

    qty = @calc.exp(:m) {50.cm + 1.lb}
    assert_in_delta(0.6, qty.value, 0.0001)
    assert_equal([:m], qty.unit[:dividends])  
    
    qty = @calc.exp(:m){10.lb}
    assert_in_delta(1, qty.value, 0.0001)
    assert_equal([:m], qty.unit[:dividends])  
  end
  
  def test_composed_conversion_usage
  
    @calc.add_unit :unit =>:t
    @calc.add_conversion 1.m => 10.lb
    @calc.add_conversion 1.lb => 10.t
  
    qty = @calc.exp(:m) {200.cm + 300.t}
  
    assert_in_delta(5, qty.value, 0.0001)
    assert_equal([:m], qty.unit[:dividends])  
  end
  
  
  def test_numeric_coerce
    @calc.add_unit :unit => :Hz
    @calc.add_conversion 1.Hz => 1.0 / 1.sec
    
    qty = @calc.exp(:sec) {60.Hz}
    
    assert_in_delta(0.016666667, qty.value, 0.0001)
    assert_equal([:sec], qty[:dividends])
  end
  
  
  def test_default_configuration_conversions
    calc = Quantity::config.calc
    
    assert_nothing_raised(RuntimeError) {
      qty = calc.exp(:mm) {1.cu_in / 1.sq_cm}
      
      assert_in_delta(163.8706, qty.value, 0.0001)
      assert_equal("mm", qty[:string])
    }
  
    
  end
end  