module Quantity

  module Quantifiable
    def quantifiable? (value)
      value && value.respond_to?(:to_quantity)
    end
  end  
    
  module Calculable
    include Quantifiable
    
    def + (value)
      perform_operation(value, :+)
    end
    
    def - (value)
      perform_operation(value, :-)
    end

    def * (value)
      perform_operation(value, :*)
    end

    def / (value)
      perform_operation(value, :/)
    end
 
    def == (other)
      return false if other == nil
      return false unless other.kind_of?(self.class)
 
      value == other.value && unit == other.unit
    end
    
    def coerce(other)
      [QuantityInfo.new(other, nil), self]
    end
  private   
 
    def perform_operation(value, operation)
      raise "Operand is not Quantifiable" unless quantifiable?(value)
      
      if value.respond_to?(:calc)
        return apply_operator(to_quantity(value.calc), value, operation)      
      end
      
      OperationInfo.new(self, value, operation)
    end  

    def apply_operator(first_operand, second_operand, operation)
      result = case operation
                 when :+ then first_operand + second_operand
                 when :- then first_operand - second_operand 
                 when :* then first_operand * second_operand 
                 when :/ then first_operand / second_operand 
               end
      return result                             
    end
    
  end


  # DSL (domain specific language) processing module. Mixin for Numeric class.		
  module Measurable
    
    def method_missing (method_name)
      QuantityInfo.new(self, method_name)
    end
    
    def to_quantity (calc)
      calc.quantity(self, nil)
    end
  end  
  
  class QuantityInfo 
  
    include Calculable
    
    attr_reader :value, :unit_sym
    
    def initialize(value, unit_sym)
      @value = value
      @unit_sym = unit_sym
    end

    def to_quantity(calc)
      calc.quantity(@value, @unit_sym)
    end  

  end

  class OperationInfo
    include Calculable

    attr_reader :first_operand, :second_operand, :operation
    
    def initialize(first_operand, second_operand, operation)

      raise "Operand is not Quantifiable" unless quantifiable?(first_operand) && 
          quantifiable?(second_operand)
  
      @first_operand = first_operand
      @second_operand = second_operand
      @operation = operation
    end
    
    def to_quantity(calc)
      first_operand = @first_operand.to_quantity(calc)
      second_operand = @second_operand.to_quantity(calc)

      return apply_operator(first_operand, second_operand, @operation)
    end  

  end


  class Quantity

    include Calculable
    
    attr_reader :calc, :value, :unit
    
    def initialize(calc, params)
      @calc = calc
      @unit = params[:unit] || Unit::ComposedUnit.new({})
      @value = params[:value] || 0.0
    end
    
    def to_quantity(calc)
      raise "Incompatible Argument." + 
          "Both operands must be created by the same calculator" unless @calc == calc
      self
    end

    # This method allows to retrieve symbolic portions of the quantity unit definition
    # and quantity value.  
    # Supported values are:
	#   :dividends - returns an array of symbols representing dividend part of 
	#                unit definition.
	#   :divisors -  returns an array of symbols representing divisor part of 
	#                unit definition.
	#   :string - string representation of the unit of measure. 
	#   :value - returns quantity value 
    def [] (symbol)
      return value if symbol == :value

      @unit[symbol]      
    end

  private

    def perform_operation(value, operation)
      raise "Operand is not Quantifiable" unless quantifiable?(value)
      
      @calc.perform_operation(self, value.to_quantity(@calc), operation)
    end
    
  end

end

# Extention to standard Numeric hierarchy to support quantity DSL
class Numeric
  include Quantity::Measurable
end
  

