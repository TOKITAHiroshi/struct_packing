require File.dirname(__FILE__) + '/../test_helper.rb'

require 'ostruct'

class TestPackable < Test::Unit::TestCase

  TEST_MOD = StructPacking::Packable

  def setup
  end

  
  
  class ClsIntNoAttr
    include TEST_MOD
    self.byte_format = "uint32_t packtestint;"
  end
  
  def test_pack_undefined_field_int
    obj = ClsIntNoAttr.new
    assert_equal( [0,0,0,0].pack("C4"), obj.pack() )
  end

  class ClsInt < ClsIntNoAttr
    include TEST_MOD
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
    include TEST_MOD
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
    self.byte_format = "uint32_t hoge; int fuga; byte piyo[1]"
  end

  def test_pack_with_ostruct
    sd = OStructTestClass.new
    sd.hoge = 1
    sd.fuga = 2
    sd.piyo = [8]
    
    ba = sd.pack()
    
    assert_equal([1, 0, 0, 0, 2, 0, 0, 0, 8].pack("C*"), ba)
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
    obj = ClsNesting.new
    nst = ClsNested.new
    obj.nst = nst
    obj.nst.ho = 1
    obj.nst.ge = 10

    assert_equal([1,0,0,0, 10].pack("C*"), obj.pack )
  end
  
  class ClsArray < OpenStruct
    include TEST_MOD
    self.byte_format = "struct ClsNested ary[2];"
  end
  
  def test_struct_array
    obj = ClsArray.new

    nst1 = ClsNested.new
    nst1.ho = 1
    nst1.ge = 10
    nst2 = ClsNested.new
    nst2.ho = 2
    nst2.ge = 20
    obj.ary = [nst1, nst2]
    
    assert_equal([1,0,0,0,10,2,0,0,0,20].pack("C*"), obj.pack )
  end
  
  class HashMapped < Hash
    include TEST_MOD
    define_struct "int hashhoge; char hashfuga;"
    hash_mapped_struct
  end

  def test_hash_struct
    obj = HashMapped.new

    obj[:hashhoge] = 1
    obj[:hashfuga] = 2
    
    assert_equal([1,0,0,0,2].pack("C*"), obj.pack)
  end
  
end
