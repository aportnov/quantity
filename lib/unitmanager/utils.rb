module ExecControl

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


class Hash
  
  def collect_for(keys) 
    results = []
      
    keys.each {|key|
      value = self[key] 
      raise "Invalid Key : #{key.to_s}" if value.nil?
      results << value
    }
    results
  end
  
end
  
  
#Extension to standard Array class. 
#Added functionality to compare array content regardless element order.
class Array
    def contains?(other_array)
      copy = dup
      other_array.each {|item| 
        return false unless i = copy.index(item)
        copy[i] = nil
      }
      true
    end
    
    def same?(other_array)
      length == other_array.length &&
      contains?(other_array)
    end

end
  
