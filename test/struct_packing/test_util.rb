require File.dirname(__FILE__) + '/../test_helper.rb'

require 'ostruct'

class TestUtil < Test::Unit::TestCase

  def setup
  end

  def test_types_to_template
    tpl = StructPacking::Util.types_to_template(["int", "char"])

    assert_equal("ic", tpl)
  end
  
  def test_array_type
    tpl = StructPacking::Util.types_to_template(["int", "char"])

    assert_equal("ic", tpl)
  end
  

  def test_pointer
    tpl = StructPacking::Util.types_to_template(["int*", "char*[4]"])

    assert_equal("PP4", tpl)
  end
  
  
end
