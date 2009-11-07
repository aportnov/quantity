module Unit

  # Implementation of what is called ‘composed unit of measure’. 
  # This is a result of performing multiplication or division of
  # quantities with simple units.
  # Example:  1 lb per in or 70 mi per hour
  class ComposedUnit
  
    include Unit::Comparable

    include Quantity::Extensions
  
    attr_reader :dividends, :divisors, :coefficient
  
    def initialize(params)
      params = Optimizer.process(params)
    
      @coefficient = params[:coefficient] || 1
      @dividends = params[:dividends] || []
      @divisors = params[:divisors] || [] 
    end
    
    def to_base(value)
      value * to_base_coef
    end
    
    def from_base(value)
      value * from_base_coef
    end
    
    # Returns unit representing hierarchy base for the given unit.
    # The Hierarchy is the "based on" chain.
    def h_base
      ComposedUnit.new({ :coefficient => 1.0,
            :dividends => Optimizer.base(@dividends),
            :divisors => Optimizer.base(@divisors) })
    end
    
    def dividend
      ComposedUnit.new({:dividends => @dividends})
    end
    
    def divisor
      ComposedUnit.new({:divisors => @divisors})
    end
    
    def reverse
      ComposedUnit.new({
        :coefficient => 1.0 / coefficient,
        :dividends => @divisors.collect{|unit| unit },
        :divisors => @dividends.collect{|unit| unit }
      })
    end
  
    # Two composed units are equal if their coefficients are the same 
    # and units contain same set of dividends and divisors.
    def ==(other)
      return false if other == nil
      return false unless other.kind_of?(self.class)
      
      result = (coefficient == other.coefficient) &&
       dividends.same_values?(other.dividends) &&
       divisors.same_values?(other.divisors)
      
      return result
    end
    
    def eql?(other)
      self == other
    end
    
    # This method allows to retrieve symbolic portions of the unit definition.
    # Supported values are:
    # 	:dividends - returns an array of symbols representing dividend part of 
    #                  unit definition.
    # 	:divisors - returns an array of symbols representing divisor part of 
    #                  unit definition.
    # 	:string - string representation of the unit of measure. 
    def [] (symbol)
      unit_sym[symbol]
    end

  private    
    
    def collect(array, &block)
      result = []
      
      array.each {|item| result += (yield(item) || []) }
      
      return result
    end
 
    def to_base_coef 
      coef = @coefficient
      @dividends.each {|unit| coef *= unit.to_base(1.0) }
      @divisors.each {|unit| coef /= unit.to_base(1.0) }
      coef
    end
 
    def from_base_coef
      coef = @coefficient
      @dividends.each {|unit| coef *= unit.from_base(1.0) }
      @divisors.each {|unit| coef /= unit.from_base(1.0) }
      coef
    end
 
    def unit_string
      buffer = {:dividends => [], :divisors => []}
        
      @dividends.each{|unit|
        if unit[:string]
          strings = unit[:string].split(/\//)
          buffer[:dividends] << strings[0]
          buffer[:divisors] << strings[1]
        end
      }        
        
      @divisors.each{|unit|
        if unit[:string]
          strings = unit[:string].split(/\//)
          buffer[:dividends] << strings[1]
          buffer[:divisors] << strings[0]
        end
      }        
        
      unit_string = buffer[:dividends].empty? ? '' : buffer[:dividends].compact.join('*')

      buffer[:divisors].compact!
      unit_string << "/" << buffer[:divisors].join('*') unless buffer[:divisors].empty?
      
      unit_string
    end
    
 
    def unit_sym
      {
        :dividends => 
          collect(@dividends){|unit| unit[:dividends]} +
          collect(@divisors){|unit| unit[:divisors]},
        :divisors => 
          collect(@divisors){|unit| unit[:dividends]} +
          collect(@dividends){|unit| unit[:divisors]},
        :string => unit_string          
      }
    end
    
    once :unit_sym, :to_base_coef, :from_base_coef, :h_base, :dividend, :divisor, :reverse, :unit_string
  end


  class Parser 
  
    def initialize(units)
      @units = units
    end
  
    def to_units(unit_spec)
  
       operands = unit_spec.split(/\//)
       raise "Invalid Number of Operands in : #{unit_spec}" if operands.size > 2
       
       {
          :dividends => @units.collect!(parse_operand_symbols(operands[0])),
          :divisors => @units.collect!(parse_operand_symbols(operands[1]))
       }   
    end
    
    def parse_operand_symbols(string)
      operands = string.nil? ? [] : string.split(/\*/)
      operands.collect{|name| name.to_sym}
    end
    
  end


  class Optimizer
  
    def Optimizer.process(params)
      raise "Incoming parameter has to respond to [] method" unless params.respond_to?(:[])
      
      #initialize local values
      coefficient = params[:coefficient] || 1
      dividends = [] + (params[:dividends] || [])
      divisors =  [] + (params[:divisors] || [])

      #create arrays of unit hierarchy bases..  
      base_dividends = base(dividends)
      base_divisors = base(divisors)

      #try to find matching units and optimize them
      base_dividends.each_index { | i |
        if index = base_divisors.index(base_dividends[i])
          coefficient *= dividends[i].to_base(1.0)
          coefficient /= divisors[index].to_base(1.0)
            
          #set 'used' units to nil, so they won't be used again  
          dividends[i] = divisors[index] = base_divisors[index] = nil
        end
      }          
         
      return {
        :coefficient => coefficient,
        :dividends => dividends.compact,
        :divisors => divisors.compact
      }
    end
 
    def Optimizer.base(units)
      units.collect {| item | item.h_base}
    end
    
  end
  
end  