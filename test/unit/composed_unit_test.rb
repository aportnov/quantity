require File.dirname(__FILE__) + '/../test_helper'


class CompasedUnitTest < Test::Unit::TestCase
  
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
    @units[:A] = SimpleUnit.new(:unit => :A)
  
  end
  
  
  def test_to_base_conversion

    unit = ComposedUnit.new({
      :dividends => [@units[:oz]]
    })

    assert_in_delta(2834.9523125, unit.to_base(100), 0.0001)

    unit = ComposedUnit.new({
      :dividends => [@units[:lb]],
      :divisors => [@units[:m]]
    })

    assert_in_delta(45.359237, unit.to_base(100), 0.0001)
  
  end
  
  def test_from_base_conversion
    unit = ComposedUnit.new({ :dividends => [@units[:oz]] })

    assert_in_delta(100, unit.from_base(2834.9523125), 0.0001)
  
    unit = ComposedUnit.new({
      :dividends => [@units[:lb]],
      :divisors => [@units[:m]]
    })

    assert_in_delta(100, unit.from_base(45.359237), 0.0001)

  end
  
  def test_equal_units
    oz = ComposedUnit.new( { :dividends => [@units[:oz]] } )
    
    lb = ComposedUnit.new( { :dividends => [@units[:lb]] })
  
    assert_not_equal(oz, lb)
    
    ozee = ComposedUnit.new({ :dividends => [@units[:oz], @units[:mm]] })
    
    mmee = ComposedUnit.new({ :dividends => [@units[:mm], @units[:oz]] })
  
    assert_equal(ozee, mmee)
  end
  
  def test_compatible_units
    oz = ComposedUnit.new( { :dividends => [@units[:oz]] } )
    lb = ComposedUnit.new( { :dividends => [@units[:lb]] })

    assert_equal(true, oz.compatible?(lb))
  
    ozee = ComposedUnit.new({ :dividends => [@units[:oz], @units[:mm]] })
    mmee = ComposedUnit.new({ :dividends => [@units[:mm], @units[:oz]] })

    assert_equal(true, ozee.compatible?(mmee))
    
    ozee = ComposedUnit.new({ :dividends => [@units[:oz], @units[:sec]] })
    mmee = ComposedUnit.new({ :dividends => [@units[:mm], @units[:oz]] })
    
    assert_equal(false, ozee.compatible?(mmee))
  end
  
  def test_get_unit
    unit = ComposedUnit.new({ 
          :dividends => [@units[:oz], @units[:sec]],
          :divisors => [@units[:mm]]})
    
    assert_equal([:oz, :sec], unit[:dividends])    
    assert_equal([:mm], unit[:divisors])    
  end
  
  def test_get_unit_string

    dividend = ComposedUnit.new({ 
          :dividends => [@units[:oz]],
          :divisors => [@units[:mm]]})

    divisor = ComposedUnit.new({ 
          :dividends => [@units[:sec]],
          :divisors => [@units[:A]]})
    
    sample = ComposedUnit.new({:dividends => [dividend], :divisors => [divisor]})
  
    assert_equal("oz*A/mm*sec", sample[:string])
  
  end
  
  def test_hierarchy_base
    unit = ComposedUnit.new({ :dividends => [@units[:lb]] })
    
    base_unit = unit.h_base
  
    assert_equal([@units[:g]], base_unit.dividends)
    assert_equal([], base_unit.divisors)
    assert_in_delta(1.0, base_unit.coefficient, 0.0001)
  end

  def test_reverse_unit
    unit = ComposedUnit.new({ 
          :coefficient => 20.0,
          :dividends => [@units[:oz], @units[:sec]],
          :divisors => [@units[:mm]]})
    
    reversed_unit = unit.reverse

    assert_equal(0.05, reversed_unit.coefficient)
    assert_equal([@units[:mm]], reversed_unit.dividends)
    assert_equal([@units[:oz], @units[:sec]], reversed_unit.divisors)  
  end
  
  def test_symbol_array_operations
    sample = [:mm, :cm, :mm] + [:cm, :lb]
  
    assert_equal([:mm, :cm, :mm, :cm, :lb], sample)
  
    sample += (nil || [])

    assert_equal([:mm, :cm, :mm, :cm, :lb], sample)
  end
  
  def test_array_contains
     assert_equal(false, [:mm, :sq_cm].contains?([:mm, :mm]))
  end

  def test_contains
    @units[:L] = SimpleUnit.new(:unit => :L)
    @units[:cu_in] = SimpleUnit.new(:unit => :cu_in, :based_on => @units[:L], :coefficient => 0.016387064)    
  
    @units[:sq_mm] = SimpleUnit.new(:unit => :sq_mm)
    @units[:sq_cm] = SimpleUnit.new(:unit => :sq_cm, :based_on => @units[:sq_mm], :coefficient => 100)

    unit = ComposedUnit.new(
      :dividends => [@units[:mm], @units[:sq_cm]],
      :divisors => [@units[:cu_in]]
    )
    
    other = ComposedUnit.new(:dividends => [@units[:mm], @units[:mm]] )
    
    assert_equal(false, unit.contains?(other))
    
  end

end