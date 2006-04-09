require File.dirname(__FILE__) + '/../test_helper'

class QuantifiableTest < Test::Unit::TestCase
  
  include Quantity

  def test_quantifiable_validation
  
    info = QuantityInfo.new(14, :mm)
  
    assert_raise(RuntimeError){ info + "Alex" }
    
    assert_nothing_raised(RuntimeError) {info + QuantityInfo.new(10, :mm)}
  
  end
  
  def test_numeric_mixin
    info = 12.mm
    assert(info.kind_of?(QuantityInfo))
    assert_equal(12, info.value)
    assert_equal(:mm, info.unit_sym)

    info = 12.566.mm
    assert(info.kind_of?(QuantityInfo))
    assert_in_delta(12.566, info.value, 0.0001)
    assert_equal(:mm, info.unit_sym)
  end

  def test_operation_mixin
    
    operation = 10.mm + 23.cm
  
    assert(operation.kind_of?(OperationInfo))
    assert(operation.first_operand.kind_of?(QuantityInfo))
    assert(operation.second_operand.kind_of?(QuantityInfo))
    assert_equal(:+, operation.operation)
    
    assert_raise(RuntimeError){ 17.lb + "Alex" }
    
    operation = (24.lb + 15.8.kg) / (3.cm - 6.mm)

    assert(operation.kind_of?(OperationInfo))
    assert(operation.first_operand.kind_of?(OperationInfo))
    assert(operation.second_operand.kind_of?(OperationInfo))
    assert_equal(:/, operation.operation)
    
    assert(operation.first_operand.first_operand.kind_of?(QuantityInfo))
    assert(operation.first_operand.second_operand.kind_of?(QuantityInfo))
    assert_equal(:+, operation.first_operand.operation)
    
    assert(operation.second_operand.first_operand.kind_of?(QuantityInfo))
    assert(operation.second_operand.second_operand.kind_of?(QuantityInfo))
    assert_equal(:-, operation.second_operand.operation)
  end
  
  def test_mixed_operation
    
    assert_nothing_raised(RuntimeError) {
      
      info = 10.mm * 10
      assert(info.kind_of?(OperationInfo))
      
      info = 10.mm + 10
      assert(info.kind_of?(OperationInfo))

      info = 10 + 34.mm
      assert(info.kind_of?(OperationInfo))
    
    }

  end

end