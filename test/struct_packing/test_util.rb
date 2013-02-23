require File.dirname(__FILE__) + '/../test_helper.rb'

require 'ostruct'


class Hoge
  include StructPacking::Packable
  define_struct "int ho; char ge;"
end

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
  
  def test_struct
    tpl = StructPacking::Util.types_to_template(["struct Hoge"])

    assert_equal("ic", tpl)
  end
  

  def test_struct_array
    tpl = StructPacking::Util.types_to_template(["struct Hoge[4]"])

    assert_equal("icicicic", tpl)
  end
  
  class TestInnerClass
    include StructPacking::Packable
    define_struct "int fu; char ga;"
  end
  
  def test_inner_module
    tpl = StructPacking::Util.types_to_template(["struct TestInnerClass[4]"], self.class)

    assert_equal("icicicic", tpl)
  end
  
  
end
