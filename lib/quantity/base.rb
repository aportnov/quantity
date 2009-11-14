module Quantity

  VERSION = '0.9.4'

  def self.quantifiable?(*value)
    [value].flatten.all?{|v| v.respond_to?(:to_quantity)}
  end
  
  module Calculations
  
    module Base
    
      def method_missing(name, value)
        if supported_operation? name
          perform_operation(value, name)
        else
          super.method_missing(name, value)
        end
      end
 
      def == (other)
        return false if other == nil
        return false unless other.kind_of?(self.class)
        value == other.value && unit == other.unit
      end
    
      def coerce(other)
        [Operand.new(other, nil), self]
      end
    private   
 
      def perform_operation(value, operation)
        raise "Operand is not Quantifiable" unless ::Quantity::quantifiable?(value, self)
      
        value.respond_to?(:calc) ? apply_operator(to_quantity(value.calc), value, operation) : Operation.new(self, value, operation)      
      end  

      def apply_operator(first_operand, second_operand, operation)
        raise "Operation #{operation.to_s} is not supported" unless supported_operation? operation    

        first_operand.send(operation, second_operand) 
      end
    
      def supported_operation?(operation)
        [:+, :-, :*, :/].include? operation 
      end
    
    end

    class Operand 
  
      include Base
    
      attr_reader :value, :unit_sym
    
      def initialize(value, unit_sym)
        @value = value
        @unit_sym = unit_sym
      end

      def to_quantity(calc)
        calc.quantity(@value, @unit_sym)
      end  

    end

    class Operation
      include Base

      attr_reader :first_operand, :second_operand, :operation
    
      def initialize(first_operand, second_operand, operation)
        [first_operand, second_operand].each do |operand| 
          raise "Operand #{operand} is not Quantifiable" unless ::Quantity::quantifiable?(operand) 
        end  
  
        @first_operand, @second_operand, @operation = first_operand, second_operand, operation
      end
    
      def to_quantity(calc)
        first_operand, second_operand = [@first_operand, @second_operand].collect{|o| o.to_quantity(calc)} 
        apply_operator first_operand, second_operand, @operation
      end  

    end

    # Mixin for classes to be able to participate in quantity operations.		
    module Mixin
      def method_missing (method_name)
        Operand.new(self, method_name)
      end

      def to_quantity(calc)
        calc.quantity(self, nil)
      end
    end  

  end


  class Quantity

    include Calculations::Base
    
    attr_reader :calc, :value, :unit
    
    def initialize(calc, params)
      @calc = calc
      @unit = params[:unit] || Unit::Composition.new({})
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
      raise "Operand is not Quantifiable" unless ::Quantity::quantifiable?(value)
      
      @calc.perform_operation(self, value.to_quantity(@calc), operation)
    end
    
  end

end

# Extention to standard Numeric hierarchy to support quantity DSL
class Numeric
  include Quantity::Calculations::Mixin
end
  

