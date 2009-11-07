module Quantity
  class Configuration
  
    def initialize
      @default = Calculator.new
      yield self if block_given?
    end
  
    def unit(params)
      @default.add_unit params
    end
  
    def conversion(params)
      @default.add_conversion params
    end
  
    def calc
      calc = Calculator.new({}.replace(@default.units))
    
      @default.conversions.each {|c| 
        calc.conversions << Quantity.new(calc, :unit => c.unit, :value => c.value)
      }
    
      return calc    
    end
  
  end

  def self.default(&block)
    @config ||= Configuration.new()
    yield @config if block_given? 
  end
  
  def self.config
    @config
  end
end