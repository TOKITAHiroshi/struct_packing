require File.dirname(__FILE__) + '/../test_helper.rb'

require 'ostruct'

class TestUnpackable < Test::Unit::TestCase

  TEST_MOD = StructPacking::Unpackable

  def setup
  end

  
  
  class ClsIntNoAttr
    include TEST_MOD
    self.byte_format = "uint32 packtestint;"
  end
  
  def test_unpack_undefined_field_int
    obj = ClsIntNoAttr.from_data( [0,0,0,0].pack("C4") )
    assert_raise(NoMethodError) do
      obj.packtestint
    end
  end

  class ClsInt < ClsIntNoAttr
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
    self.byte_format = "uint32 hoge; int fuga; byte piyo[1]"
  end

  def test_from_data_with_ostruct
    ud = OStructTestClass.from_data [1, 0, 0, 0, 2, 0, 0, 0, 8, 9].pack("C*")
    
    assert_equal(1, ud.hoge)
    assert_equal(2, ud.fuga)
    assert_equal([8], ud.piyo)
  end

end
