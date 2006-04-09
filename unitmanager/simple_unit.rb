#Extension to standard Array class. 
#Added functionality to compare array content regardless element order.
class Array
    def contains?(other_array)
      other_array.each {|item| 
        return false unless index(item)
      }
      true
    end
    
    def same?(other_array)
      length == other_array.length &&
      contains?(other_array)
    end

end


module Unit
  
  # Adds comparing capabilities to  unit implementations
  module Comparable

     #Two units are compatible if they have same hierarchy base
     #Example :cm is compatible with :in, since they both based on :mm   
     def compatible? (other)
      return false if other == nil
      return false unless other.respond_to?(:h_base)

      h_base[:dividends].same?(other.h_base[:dividends]) &&
      h_base[:divisors].same?(other.h_base[:divisors])
    end
    
    def contains? (other)
      return false if other == nil
      return false unless other.respond_to?(:h_base)

      h_base[:dividends].contains?(other.h_base[:dividends]) &&
      h_base[:divisors].contains?(other.h_base[:divisors])
    end
  end
  

  # Implementation of what is called ‘simple unit of measure’. 
  # This is a linear unit which is optionally based on some other 
  # simple unit with linear coefficient.
  # Example:  :cm is based on :mm with coefficient equal 10.
  # In other words X cm = 10 * Y mm. 
  class SimpleUnit
  
      include Unit::Comparable
  
      attr_reader :unit, :coefficient, :based_on
  
  	  def initialize (args)
        @unit = args[:unit]
        @based_on = args[:based_on] || nil
        @coefficient = args[:coefficient] || 1
      end
  
      def to_base(value)
        value = @based_on.to_base(value) if derived?
        
        value *= @coefficient
      end
  
      def from_base(value)
        value = @based_on.from_base(value) if derived?
        
        value /= @coefficient
      end
      
      # This method allows to retrieve symbolic portions of the unit definition.
      # Supported values are:
      # 	:dividends - returns an array of symbols representing dividend part of 
	  #                  unit definition.
      # 	:divisors - returns an array of symbols representing divisor part of 
	  #                  unit definition.
      # 	:string - string representation of the unit of measure. 
      def [] (symbol)
        @unit_sym = {:dividends => [@unit], :divisors => [], :string => @unit.to_s} unless @unit_sym
        
        @unit_sym[symbol]
      end
  
      # Returns unit representing hierarchy base for the given unit.
      # The Hierarchy is the "based on" chain.
      def h_base
        derived? ? @based_on.h_base : self
      end
      
      # Two Simple units are equal if they have same symbol, 
      # based on the same unit with the same coefficient
      def ==(other)
        return false if other == nil
        return false unless other.kind_of?(self.class)
        
        unit == other.unit && based_on == other.based_on && coefficient == other.coefficient     
      end
      
      def eql?(other)
        self == other
      end

  private        
      def derived?
        @based_on != nil
      end
  
  end

end
