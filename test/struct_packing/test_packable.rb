require File.dirname(__FILE__) + '/../test_helper.rb'

require 'ostruct'

class TestPackable < Test::Unit::TestCase

  TEST_MOD = StructPacking::Packable

  def setup
  end

  
  
  class ClsIntNoAttr
    include TEST_MOD
    self.byte_format = "uint32 packtestint;"
  end
  
  def test_pack_undefined_field_int
    obj = ClsIntNoAttr.new
    assert_equal( [0,0,0,0].pack("C4"), obj.pack() )
  end

  class ClsInt < ClsIntNoAttr
    attr_accessor :packtestint
  end

  def test_pack_field_int
    obj = ClsInt.new
    obj.packtestint = 1
    assert_equal( [1,0,0,0].pack("C4"), obj.pack() )
  end

  class ClsCharNoAttr
    include TEST_MOD
    self.byte_format = "char packtestchar;"
  end
  
  def test_pack_undefined_field_char
    obj = ClsCharNoAttr.new
    assert_equal( [0].pack("C"), obj.pack() )
  end

  class ClsChar < ClsCharNoAttr
    attr_accessor :packtestchar
  end

  def test_pack_field_char
    obj = ClsChar.new
    obj.packtestchar = 1
    assert_equal( [1].pack("C"), obj.pack() )
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

  def test_pack_multi_field
    obj = ClsMultiField.new
    obj.packtestint = 1
    obj.packtestchar = 1
    assert_equal( [1, 1, 0, 0, 0].pack("C*"), obj.pack() )
  end

  class OStructTestClass < OpenStruct
    include TEST_MOD
    self.byte_format = "uint32 hoge; int fuga; byte[1] piyo"
  end

  def test_pack_with_ostruct
    sd = OStructTestClass.new
    sd.hoge = 1
    sd.fuga = 2
    sd.piyo = [8]
    
    ba = sd.pack()
    
    assert_equal([1, 0, 0, 0, 2, 0, 0, 0, 8].pack("C*"), ba)
  end

end
