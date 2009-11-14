module Quantity

  class Calculator
    attr_reader :units, :conversions
    
    def initialize(units = {}, conversions = [])
      @units = units
      @parser ||= Unit::Parser.new(@units)
      @conversions ||= conversions
    end
    
    def quantity(value, unit_sym)
      return Quantity.new(self, {:value => value.to_f, :unit => to_unit(unit_sym)})
    end
    
    def perform_operation(first_operand, second_operand, operation)
      result = case operation
                 when :+ then add(first_operand, second_operand)
                 when :- then subtract(first_operand, second_operand)
                 when :* then multiply(first_operand, second_operand)
                 when :/ then divide(first_operand, second_operand)
                 else
                  raise "Operation #{operation.to_s} is not supported"
               end
      return result                             
    end
 
    def exp (return_as = nil)
      operand = yield self
      raise "Operand is not Quantifiable" unless ::Quantity::quantifiable?(operand)
      convert_to(operand.to_quantity(self), to_unit(return_as))
    end
    
    def add_unit(params)
      raise "Unit symbol is required" unless (unit_sym = params[:unit])
      
      raise "Unit with symbol: #{unit_sym.to_s} already defined" if @units[unit_sym]
      
      if (based_on_sym = params[:based_on])
        raise "Invalid configuration. " +
           "Based_on unit must be defined before used." unless (based_on = @units[based_on_sym]) 
      end
      
      @units[unit_sym] = Unit::Base.new({
        :unit => unit_sym, 
        :based_on => based_on, 
        :coefficient => params[:coefficient] || 1.0 
        })      
    end

    def add_conversion(params)
      params.each do |source, target|
        begin
          @conversions << exp { target / source } << exp { source / target }
        rescue
          raise "Unit must be defined before used in conversion"
        end  
      end      
    end
    
  private 
  
    def add (first_operand, second_operand) 
      converted_second_operand = convert_to(second_operand, first_operand.unit)
    
      value = first_operand.value + converted_second_operand.value
 
      Quantity.new(self,{:value => value, :unit => first_operand.unit})
    end
    
    def subtract (first_operand, second_operand) 
      converted_second_operand = convert_to(second_operand, first_operand.unit)
      
      value = first_operand.value - converted_second_operand.value
 
      Quantity.new(self,{:value => value, :unit => first_operand.unit})
    end

    def multiply (first_operand, second_operand) 
      value = first_operand.value * second_operand.value
      
      unit = Unit::Composition.new({
        :dividends => 
          @units.collect!(first_operand[:dividends] + second_operand[:dividends]),
        :divisors => 
          @units.collect!(first_operand[:divisors] + second_operand[:divisors])          
      })  
      
      Quantity.new(self, {:value => value, :unit => unit})      
    end
    
    def divide (first_operand, second_operand) 
      value = second_operand.value == 0 ? 0 : first_operand.value / second_operand.value
 
      unit = Unit::Composition.new({
        :dividends => 
          @units.collect!(first_operand[:dividends] + second_operand[:divisors]),
        :divisors => 
          @units.collect!(first_operand[:divisors] + second_operand[:dividends])          
      })  
      
      Quantity.new(self, {:value => value, :unit => unit})      
    end
 
    def convert_to(qty, unit)
      unit = qty.unit.h_base if unit.nil?

      return qty if qty.unit == unit

      if qty.unit.compatible?(unit)
        value = unit.from_base(qty.unit.to_base(qty.value))
        return Quantity.new(self, {:value => value, :unit => unit})    
      end

      if (reverse = exp {1 / qty} ).unit.compatible?(unit)
        return convert_to(reverse, unit)
      end
      
      if conversion = find_conversion( :from => qty.unit, :to => unit)
        return convert_to(exp {qty * conversion}, unit)
      end
      
      if conversion = find_conversion( :from => reverse.unit, :to => unit)
        return convert_to(exp {reverse * conversion}, unit)
      end

      raise "Incompatible Units: #{qty[:string]} and #{unit[:string]} " unless conversion
    end
  
    def to_unit(return_spec)
      return nil if return_spec.nil?
      
      return return_spec.to_quantity(self).unit if ::Quantity::quantifiable?(return_spec)
      
      if return_spec.respond_to?(:split)
        return Unit::Composition.new(@parser.to_units(return_spec))        
      end  
      
      raise "Return Unit Expression Error: Invalid Unit Specification " unless unit = @units[return_spec]
      unit     
    end
    
    def find_conversion (params)

      from, to = params[:from], params[:to]
      
      target = Unit::Composition.new({ 
        :dividends => @units.collect!(to[:dividends] + from[:divisors]), 
        :divisors => @units.collect!(to[:divisors] + from[:dividends]) 
      }) 
     
      if (conversion = direct_conversion(target))
        return conversion 
      end
      
      return composed_conversion(target)
    end
    
    def direct_conversion(target)
      @conversions.each {|c| 
          return exp(target[:string]) {c}  if c.unit == target.h_base
      }
      nil
    end
    
    def composed_conversion(target)
      convs, conv = [], Quantity.new(self, :unit => target, :value => 1)
      @conversions.each {|c|
          if conv.unit.contains?(c.unit.dividend)
            convs << c; conv /= c 
          end

          if conv.unit[:dividends] == [] && conv.unit[:divisors] == []
              conv = 1
              convs.each {|c| conv *= c}
              return conv
          end 
      }
      nil    
    end
  end

end