require File.dirname(__FILE__) + '/test_helper'

class BaseTest < Test::Unit::TestCase

    include Unit

	def setup
      @millimeter = Base.new(:unit => :mm)
  	  @centimeter = Base.new(:unit => :cm, :based_on => @millimeter, :coefficient => 10)
  	  @meter = Base.new(:unit => :m, :based_on => @centimeter, :coefficient => 100)

      @g = Base.new(:unit => :g)
      @oz = Base.new(:unit => :oz, :based_on => @g, :coefficient => 28.349523125)
      @lb = Base.new(:unit => :lb, :based_on => @oz, :coefficient => 16)
    end
	
	def test_to_base_conversion

      assert_equal(@centimeter, @meter.based_on)
      assert_equal( 10000.0, @meter.to_base(10))
      assert_equal( 100.0, @centimeter.to_base(10))
      assert_equal( @meter.to_base(1), @centimeter.to_base(100))

      assert_in_delta(28.349523125 * 16, @lb.to_base(1), 0.0001)

	end

    def test_from_base_conversion
      
      assert_equal(10.0, @meter.from_base(10000))
      assert_equal(10.0, @centimeter.from_base(100))
        
    end
    
    def test_hierarchy_base
      
      assert_equal(@g, @lb.h_base)
      
    end
    
    def test_compatible_units
      
      assert_equal(true, @millimeter.compatible?(@meter))
      assert_equal(true, @millimeter.compatible?(@centimeter))

      assert_equal(false, @millimeter.compatible?(@g))
      assert_equal(false, @millimeter.compatible?(@lb))

      assert_equal(true, @lb.compatible?(@oz))
      assert_equal(true, @oz.compatible?(@g))
    end
    
    def test_string_unit
      
      assert_equal("mm", @millimeter[:string])
      assert_equal("cm", @centimeter[:string])
      
    end
end