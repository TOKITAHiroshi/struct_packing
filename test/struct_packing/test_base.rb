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
    assert_equal({}, obj.send(:internal_format) )
  end
  

  class SingleIntStruct
    include StructPacking::Base
    self.byte_format = "int hoge;"
  end
  
  def test_single_int_internal_format
    assert_equal("int" , SingleIntStruct.send(:internal_format)[:hoge])
  end

  class MultiFieldStruct
    include StructPacking::Base
    self.byte_format = "int fuga; char piyo"
  end

  def test_multi_field_internal_format
    assert_equal("int" , MultiFieldStruct.send(:internal_format)[:fuga])
    assert_equal("char" , MultiFieldStruct.send(:internal_format)[:piyo])
  end
  
  def test_class_macro
    eval <<-EOF
      class TestClassMacro
        include StructPacking::Base
        define_struct "int foo;"
      end
    EOF
    
    assert_equal({:foo=>"int"}, TestClassMacro.send(:internal_format) )
  end

  class NotModifiableFormat
    include StructPacking::Base
    self.byte_format = "int xxx;"
  end
  
  def test_internal_format_not_modifiable
    assert_equal("int", NotModifiableFormat.send(:internal_format)[:xxx])
    SingleIntStruct.send(:internal_format)[:xxx] = "byte"
    assert_equal("int", (NotModifiableFormat.send(:internal_format)[:xxx]))
  end
  
  class InnerModuleClass
    include StructPacking::Base
    self.byte_format = "int inner; char mod;"
  end
  
  class InnerModuleTest
    include StructPacking::Base
    self.byte_format =  "struct InnerModuleClass imc;"
  end
  
  def test_inner_struct_class
    assert_equal("ic", InnerModuleTest.pack_template)
  end
  
  
end
