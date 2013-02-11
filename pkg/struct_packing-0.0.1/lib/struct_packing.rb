$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module StructPacking
  VERSION = '0.0.1'
end

require 'struct_packing/base'
require 'struct_packing/util'
require 'struct_packing/packable'
require 'struct_packing/unpackable'
  