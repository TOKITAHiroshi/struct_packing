require File.dirname(__FILE__) + '/../test_helper.rb'

require 'ostruct'

class TestUnpackable < Test::Unit::TestCase

  TEST_MOD = StructPacking::Unpackable

  def setup
  end

  
  
  class ClsIntNoAttr
    include TEST_MOD
    self.byte_format = "uint32_t packtestint;"
  end
  
  def test_unpack_undefined_field_int
    obj = ClsIntNoAttr.from_data( [0,0,0,0].pack("C4") )
    assert_raise(NoMethodError) do
      obj.packtestint
    end
  end

  class ClsInt < ClsIntNoAttr
    include TEST_MOD
    attr_accessor :packtestint
  end

  def test_unpack_field_int
    obj = ClsInt.from_data( [1,0,0,0].pack("C4") )
    assert_equal(1 , obj.packtestint)
  end

  class ClsCharNoAttr
    include TEST_MOD
    self.byte_format = "char packtestchar;"
  end
  
  def test_unpack_undefined_field_char
    obj = ClsCharNoAttr.from_data( [1].pack("C") )
    assert_raise(NoMethodError) do
      obj.packtestchar
    end
  end

  class ClsChar < ClsCharNoAttr
    include TEST_MOD
    attr_accessor :packtestchar
  end

  def test_unpack_field_char
    obj = ClsChar.from_data( [1].pack("C") )
    assert_equal(1 , obj.packtestchar)
  end

  class ClsMultiField
    include TEST_MOD
    attr_accessor :packtestchar, :packtestint

    self.byte_format = "char packtestchar; int packtestint"
    
    def initialize
      @packtestint = 9999
      @packtestchar = 9999
    end
  end

  def test_unpack_multi_field
    obj = ClsMultiField.from_data( [1, 1, 0, 0, 0].pack("C*") )
    assert_equal(1,  obj.packtestint)
    assert_equal(1,  obj.packtestchar)
  end

  class OStructTestClass < OpenStruct
    include TEST_MOD
    self.byte_format = "uint32_t hoge; int fuga; byte piyo[1]"
  end

  def test_from_data_with_ostruct
    ud = OStructTestClass.from_data [1, 0, 0, 0, 2, 0, 0, 0, 8, 9].pack("C*")
    
    assert_equal(1, ud.hoge)
    assert_equal(2, ud.fuga)
    assert_equal([8], ud.piyo)
  end
  
  class ClsNested < OpenStruct
    include TEST_MOD
    self.byte_format = "int ho; char ge;"
  end
  
  class ClsNesting < OpenStruct
    include TEST_MOD
    self.byte_format = "struct ClsNested nst;"
  end

  def test_struct
    obj = ClsNesting.from_data([1,0,0,0, 10].pack("C*"))
    assert_equal(1, obj.nst.ho)
    assert_equal(10, obj.nst.ge)
  end
  
  class ClsArray < OpenStruct
    include TEST_MOD
    self.byte_format = "struct ClsNested ary[2];"
  end
  
  def test_struct_array
    obj = ClsArray.from_data([1,0,0,0,10,2,0,0,0,20].pack("C*"))
      
    assert_equal(1, obj.ary[0].ho)
    assert_equal(10, obj.ary[0].ge)
    assert_equal(2, obj.ary[1].ho)
    assert_equal(20, obj.ary[1].ge)
    
  end
  
  
  
end
