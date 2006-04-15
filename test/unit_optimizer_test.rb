require File.dirname(__FILE__) + '/test_helper'

class UnitOptemizerTest < Test::Unit::TestCase

  include Unit

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
 
  end

  def test_no_units
      results = Optimizer.process({
        :dividends => [], :divisors => []
      })
  
      assert_equal(true, results.kind_of?(Hash))
      assert_equal(1.0, results[:coefficient])
      assert_equal([], results[:dividends])
      assert_equal([], results[:divisors])
  end

  def test_no_optimization_needed

      results = Optimizer.process({
        :dividends => [@units[:mm], @units[:sec]], :divisors => [@units[:g]]
      })
  
      assert_equal(true, results.kind_of?(Hash))
      assert_equal(1.0, results[:coefficient])
      assert_equal([@units[:mm], @units[:sec]], results[:dividends])
      assert_equal([@units[:g]], results[:divisors])
  
  end

  def test_simple_optimization

      results = Optimizer.process({
        :dividends => [@units[:mm], @units[:kg]], :divisors => [@units[:g]]
      })
  
      assert_equal(true, results.kind_of?(Hash))
      assert_equal(1000.0, results[:coefficient])
      assert_equal([@units[:mm]], results[:dividends])
      assert_equal([], results[:divisors])

  end
  
  def test_existing_coefficient_optimization
      results = Optimizer.process({
        :coefficient => 7,
        :dividends => [@units[:mm], @units[:kg]], 
        :divisors => [@units[:g]]
      })
  
      assert_equal(true, results.kind_of?(Hash))
      assert_in_delta(7000.0, results[:coefficient], 0.001)
      assert_equal([@units[:mm]], results[:dividends])
      assert_equal([], results[:divisors])
  end
  
  def test_multiple_step_optimization

      results = Optimizer.process({
        :dividends => [@units[:mm], @units[:kg]], :divisors => [@units[:lb]]
      })
  
      assert_equal(true, results.kind_of?(Hash))
      assert_in_delta(2.204622622, results[:coefficient], 0.00001)
      assert_equal([@units[:mm]], results[:dividends])
      assert_equal([], results[:divisors])
  end
  
  def test_full_unit_optimization
      results = Optimizer.process({
        :dividends => [@units[:mm], @units[:kg]], :divisors => [@units[:lb], @units[:cm] ]
      })
  
      assert_equal([], results[:dividends])
      assert_equal([], results[:divisors])
  end

  # Just to make sure it is Ok to use.
  def test_array_intersection
    intersection = [@units[:g], @units[:mm]] & [@units[:g]]
    assert_equal([@units[:g]], intersection)
    
    intersection = [@units[:g], @units[:g], @units[:mm]] & [@units[:g], @units[:g],]
    assert_equal([@units[:g]], intersection)
  end
  
end  