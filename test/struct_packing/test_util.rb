require File.dirname(__FILE__) + '/../test_helper.rb'

require 'ostruct'

class TestUtil < Test::Unit::TestCase

  def setup
  end

  def test_types_to_template
    tpl = StructPacking::Util.types_to_template(["int", "char"])

    assert_equal("ic", tpl)

  end
  
end
