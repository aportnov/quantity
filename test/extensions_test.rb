require File.dirname(__FILE__) + '/test_helper'

class ExtensionTest < Test::Unit::TestCase

  def test_hash_should_collect_values_4_keys
    hash = {:a => 1, :b => 2, :c => 3}
    
    assert_equal [1, 3], hash.collect!(:a, :c)
    assert_equal [1, 2], hash.collect!([:a, :b])
    assert_raise(RuntimeError){ hash.collect!([:a, :d, :p, :b]) }
  end

  def test_array_contains_values
    array = [1, 2, 3, 1, 3]
    
    assert array.contains?(1, 3, 3)
    assert array.contains?(1, 2, 3)
    assert !array.contains?(1, 2, 2, 3)
  end
  
  def test_array_has_same_values

    assert_not_equal [1,2,3,4], [3,2,4,1]
    
    assert [1,2,3,4].same_values?([3,2,4,1])
    assert [1,3,3,4].same_values?([3,4,3,1])
    assert [1,2,3,4].same_values?([3,4,2,1])
    assert ![1,3,3,4].same_values?([5,4,3,1])
    
  end

end