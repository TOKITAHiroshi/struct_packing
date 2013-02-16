require File.dirname(__FILE__) + '/../test_helper.rb'

require 'ostruct'

class TestBase < Test::Unit::TestCase

  def setup
  end

  class ClassIncludeOnly
    include StructPacking::Base
  end
  
  def test_null_internal_format
    obj = ClassIncludeOnly.new
    assert_equal({}, obj.internal_format())
  end
  

  class SingleIntStruct
    include StructPacking::Base
    self.byte_format = "int hoge;"
  end
  
  def test_single_int_internal_format
    assert_equal("int" , SingleIntStruct.internal_format[:hoge])
  end

  class MultiFieldStruct
    include StructPacking::Base
    self.byte_format = "int fuga; char piyo"
  end

  def test_multi_field_internal_format
    assert_equal("int" , MultiFieldStruct.internal_format[:fuga])
    assert_equal("char" , MultiFieldStruct.internal_format[:piyo])
  end

=begin
  def test_internal_format_not_modifiable
    assert_equal(4, (SingleIntStruct.internal_format[:hoge])[:size])
    (SingleIntStruct.internal_format[:hoge])[:size] = 8
    assert_equal(8, (SingleIntStruct.internal_format[:hoge])[:size])
    assert_equal({:type=>"int", :start=>0, :size=>4} , SingleIntStruct.internal_format[:hoge])
  end
=end 
  
end
