require File.dirname(__FILE__) + '/test_helper'

class QuantityTest < Test::Unit::TestCase

  include Unit
  include Quantity

  def setup
 
    @units = {}
    @units[:mm] = SimpleUnit.new(:unit => :mm)
    @units[:cm] = SimpleUnit.new(:unit => :cm, :based_on => @units[:mm], :coefficient => 10)  
    @units[:m] = SimpleUnit.new(:unit => :m, :based_on => @units[:cm], :coefficient => 100)

    @units[:g] = SimpleUnit.new(:unit => :g)
    @units[:kg] = SimpleUnit.new(:unit => :kg, :based_on => @units[:g], :coefficient => 1000.0)
    @units[:oz] = SimpleUnit.new(:unit => :oz, :based_on => @units[:g], :coefficient => 28.349523125)
    @units[:lb] = SimpleUnit.new(:unit => :lb, :based_on => @units[:oz], :coefficient => 16)
    @units[:mg] = SimpleUnit.new(:unit => :mg, :based_on => @units[:g], :coefficient => 0.001)

    @units[:sec] = SimpleUnit.new(:unit => :sec)
  
    @calc = Calculator.new(@units)
  end


  def test_simple_operation
    q = @calc.quantity(10, :mm)

    assert_nothing_raised(RuntimeError){ q + 10.cm}
    
    assert_raise(RuntimeError){ 15.lb - q}
    
    assert_raise(RuntimeError) { (14.mm + 34.7.ft) - q}

    qty = (14.mm + 4.9.cm) * q
    
    assert_not_nil(qty)
    assert_in_delta(630, qty.value, 0.001)
    assert_equal([:mm,:mm], qty[:dividends])
    
    qty = 14.m * q
    assert_not_nil(qty)
  end

  def test_quantity_info_conversion
    
    qty = 14.m.to_quantity(@calc)
    assert_not_nil(qty)
    assert_equal(14, qty.value)
    assert_equal([:m], qty[:dividends])
    
    qty = qty * @calc.quantity(5, :lb)
    assert(qty)
    assert_equal(14 * 5, qty.value)
    assert_equal([:m, :lb], qty[:dividends])
  end

  def test_quantity_value
    q = @calc.quantity(10, :mm)

    assert_equal(10.0, q.value)    
  end
  
  def test_quantity_unit

    q = @calc.quantity(10, :mm)
    
    assert_equal([:mm], q[:dividends])
    assert_equal([], q[:divisors])  
  end

  def test_string_unit
    q = @calc.quantity(10, :mm) * @calc.quantity(5, :lb)
    
    assert_equal("mm*lb", q[:string])
  end

  def test_method_missing
    
    assert_nothing_raised(NoMethodError) {
      10.lb + 5.kg
      @calc.quantity(10, :mm) + 25.cm
    }
    assert_raise(NoMethodError) { 10.lb % 3.kg}

    assert_raise(NoMethodError) { 
      @calc.quantity(10, :mm).hello("Alex")
    }
  end

end