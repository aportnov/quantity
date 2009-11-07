module Quantity
  module Extensions
    
    module ClassMethods
      def once (*methods) #:nodoc:
        methods.each {|method| 

          module_eval <<-"end;"
            alias_method :__#{method.to_i}__ , :#{method.to_s}

            def #{method.to_s}(*args, &block)

              def self.#{method.to_s}(*args, &block)
                @__#{method.to_i}__ 
              end

              @__#{method.to_i}__ = __#{method.to_i}__(*args, &block)
            end
            private :__#{method.to_i}__

          end;

        }
      end

      private :once
    end  
    
    module InstanceMethods
    end
    
    def self.included(base)
      base.send :extend,  Quantity::Extensions::ClassMethods
      base.send :include, Quantity::Extensions::InstanceMethods
    end

    # Standard Library Extensions ========================
    
    module Hash
      module InstanceMethods

        def collect!(*keys)
          keys.flatten.inject([]) do |result, key| 
            value = (self[key] || self[key.to_sym])
            raise "No value found for a key #{key}" unless value
            result << value
          end
        end

      end
    end
  
    module Array
      module InstanceMethods

        def contains?(*values)
          copy, other = self.dup, values.flatten.compact
          other.all? do |item|
            index = copy.index(item)
            copy[index] = nil if index
            index
          end
        end

        def same_values?(*values)
          other = values.flatten
          self.size == other.size && self.contains?(other)
        end

      end
    end

    
  end  
end

class Hash
  include Quantity::Extensions::Hash::InstanceMethods
end

class Array
  include Quantity::Extensions::Array::InstanceMethods
end