require File.dirname(__FILE__) + '/test_helper'

include Quantity
include Quantity::Unit

class CalculatorTest < Test::Unit::TestCase

  def setup

    @units = {}
    @units[:mm] = Base.new(:unit => :mm)
    @units[:cm] = Base.new(:unit => :cm, :based_on => @units[:mm], :coefficient => 10)  
    @units[:m] = Base.new(:unit => :m, :based_on => @units[:cm], :coefficient => 100)

    @units[:g] = Base.new(:unit => :g)
    @units[:kg] = Base.new(:unit => :kg, :based_on => @units[:g], :coefficient => 1000.0)
    @units[:oz] = Base.new(:unit => :oz, :based_on => @units[:g], :coefficient => 28.349523125)
    @units[:lb] = Base.new(:unit => :lb, :based_on => @units[:oz], :coefficient => 16)
    @units[:mg] = Base.new(:unit => :mg, :based_on => @units[:g], :coefficient => 0.001)

    @units[:sec] = Base.new(:unit => :sec)
    
    @calc = Calculator.new(@units)
  
  end


  def test_quantity_creation
    qty = @calc.quantity(45.897, :mm)
    
    assert_in_delta(45.897, qty.value, 0.0001)
    assert_equal([:mm], qty[:dividends])
    assert_equal([], qty[:divisors])
    
    
    qty = @calc.quantity(57.345, "mm/lb")
    assert_in_delta(57.345, qty.value, 0.0001)
    assert_equal([:mm], qty[:dividends])
    assert_equal([:lb], qty[:divisors])
  end
  
  def test_calculator_expression_method
    qty = @calc.exp {5.lb}
    assert(qty.kind_of?(Quantity))
    
    qty = @calc.exp {12.mm + 34.7.cm}
    assert(qty.kind_of?(Quantity))
    
    qty = @calc.quantity(45, :cm)
    assert_equal(qty, @calc.exp(:cm) {qty})
  end
 
  def test_convert_to

    qty = @calc.quantity(45, :cm)
 
    base = @calc.exp(1.mm) {qty}
    
    assert_in_delta(450.0, base.value, 0.0001)
    assert_equal([:mm], base[:dividends]) 
    
    base = @calc.exp(:mm) {qty}
    
    assert_in_delta(450.0, base.value, 0.0001)
    assert_equal([:mm], base[:dividends]) 
    
    base = @calc.exp("mm") {qty}
    
    assert_in_delta(450.0, base.value, 0.0001)
    assert_equal([:mm], base[:dividends]) 
  end
  
  def test_complex_conver_to
    @calc.add_unit :unit => :km, :based_on => :m, :coefficient => 1000
    @calc.add_unit :unit => :in, :based_on => :cm, :coefficient => 2.54
    @calc.add_unit :unit => :ft, :based_on => :in, :coefficient => 12
    @calc.add_unit :unit => :yd, :based_on => :ft, :coefficient => 3
    @calc.add_unit :unit => :mi, :based_on => :yd, :coefficient => 1760
    @calc.add_unit :unit => :min, :based_on => :sec, :coefficient => 60
    @calc.add_unit :unit => :hour, :based_on => :min, :coefficient => 60

    qty = @calc.exp(1.km/1.hour) {70.mi / 1.hour}
    assert_in_delta(112.654, qty.value, 0.0001)
  end
  
  def test_reverse_unit_conversion
    @calc.add_unit :unit => :km, :based_on => :m, :coefficient => 1000
    @calc.add_unit :unit => :L
    @calc.add_unit :unit => :gal, :based_on => :L, :coefficient => 3.785332
    @calc.add_unit :unit => :in, :based_on => :cm, :coefficient => 2.54
    @calc.add_unit :unit => :ft, :based_on => :in, :coefficient => 12
    @calc.add_unit :unit => :yd, :based_on => :ft, :coefficient => 3
    @calc.add_unit :unit => :mi, :based_on => :yd, :coefficient => 1760

    qty = @calc.exp(1.mi/1.gal) {5.5.L/100.km}      
    assert_in_delta(42.765, qty.value, 0.001)

  end
  
  def test_simple_same_base_add
    
    qty = @calc.exp(:cm){2.m + 17.8.cm}

    assert_in_delta(217.8, qty.value, 0.0001)
    assert_equal([:cm], qty[:dividends]) 

    assert_raise(RuntimeError) {
      @calc.exp(:cm){2.m + 17.8}
    }
  end

  def test_simple_same_base_subtract
    qty = @calc.exp(:cm){2.m - 20.cm}

    assert_in_delta(180, qty.value, 0.0001)
    assert_equal([:cm], qty[:dividends]) 

    assert_raise(RuntimeError) {
      @calc.exp(:cm){2.m - 5.7}
    }
  end

  def test_simple_multiply
    qty = @calc.exp(1.cm * 1.oz) {10.m * 5.lb}
    
    assert_in_delta(80000, qty.value, 0.0001)
    assert_equal([:cm, :oz], qty[:dividends]) 

    qty = @calc.exp(:m) {10.m * 5}
    
    assert_in_delta(50, qty.value, 0.0001)
    assert_equal([:m], qty[:dividends]) 
  end

  def test_simple_divide
    qty = @calc.exp(1.cm / 1.oz) {10.m / 5.lb}
    
    assert_in_delta(12.5, qty.value, 0.0001)
    assert_equal([:cm], qty[:dividends]) 
    assert_equal([:oz], qty[:divisors]) 

    qty = @calc.exp(:m) {10.m / 5}
    
    assert_in_delta(2, qty.value, 0.0001)
    assert_equal([:m], qty[:dividends]) 
    
    qty = @calc.exp {25.6.lb / 0}
    assert_in_delta(0, qty.value, 0.0001)
    assert_equal([:g], qty[:dividends]) 
  end
  
  def test_string_unit_spec
    qty = @calc.exp("cm/oz") {10.m / 5.lb}
    
    assert_in_delta(12.5, qty.value, 0.0001)
    assert_equal([:cm], qty[:dividends]) 
    assert_equal([:oz], qty[:divisors]) 
  
  end
  
  def test_different_calculation_approaches
    qty = @calc.exp(:m) {25.cm + 15.8.mm + 10.m}
    
    result = @calc.exp(:m){ 35.cm + qty }
    assert_in_delta(10.6158, result.value, 0.001)
    
    assert_in_delta(1076.58, (15.cm + result)[:value], 0.001)
  end
  
  def test_add_unit
    assert_nothing_raised(RuntimeError) {
      @calc.add_unit({:unit=> :V})
      qty = @calc.quantity(15, :V)
      assert_equal("V", qty[:string])
      @calc.add_unit({:unit => :mV, :based_on => :V, :coefficient => 0.001})

      qty = @calc.quantity(15, :mV)
      assert_equal("mV", qty[:string])
      assert_equal([:V], qty.unit.h_base[:dividends])
    }
    
    assert_raise(RuntimeError) {
      @calc.add_unit :unit => :mW, :based_on => :W, :coefficient => 0.001
    }
      
  end

  def test_add_existing_unit
    assert_raise(RuntimeError) {
      @calc.add_unit :unit => :cm, :based_on => :mm, :coefficient => 10
    }  
  end
  
end