require File.dirname(__FILE__) + '/test_helper.rb'

require 'ostruct'

class TestStructPacking < Test::Unit::TestCase

  def setup
  end
  
  def test_truth
    assert true
  end

  class UserData < OpenStruct
    include StructPacking::Unpackable
    self.byte_format = {:hoge=>"uint32", :fuga=>"int", :piyo=> "byte[1]"}
  end
  
  class SysData < OpenStruct
    include StructPacking::Packable
    self.byte_format = "uint32 hoge; int fuga; byte[1] piyo;"#{:hoge=>"uint32", :fuga=>"int", :piyo=> "byte[1]"}
  end
  
  def test_from_data_with_ostruct
    ud = UserData.from_data [1, 0, 0, 0, 2, 0, 0, 0, 8, 9].pack("C*")

    assert_equal(1, ud.hoge)
    assert_equal(2, ud.fuga)
    assert_equal([8], ud.piyo)
  end
  


  def test_pack_with
    sd = SysData.new
    sd.hoge = 1
    sd.fuga = 2
    sd.piyo = [8]
    
    
    ba = sd.pack()
    
    assert_equal([1, 0, 0, 0, 2, 0, 0, 0, 8].pack("C*"), ba)
  end
  
end
