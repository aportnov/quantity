class Configuration
  
  def initialize
    @default = Quantity::Calculator.new
    yield self if block_given?
  end
  
  def unit (params)
    @default.add_unit params
  end
  
  def conversion (params)
    @default.add_conversion params
  end
  
  def calc
    calc = Quantity::Calculator.new({}.replace(@default.units))
    
    @default.conversions.each {|c| 
      calc.conversions << Quantity::Quantity.new(calc, :unit => c.unit, :value => c.value)
    }
    
    return calc    
  end
  
end