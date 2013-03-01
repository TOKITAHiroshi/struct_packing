$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))


# StructPacking package make up with Packable and Unpackable module.
#
# Include these module to a class, struct defining method and 
# packing/unpacing methods append to the class and instances.
#
# First, call struct defining method with "C-like sturucture declaration",
# and the class and instances can packing or unpacking by these methods.
module StructPacking
  # Gem version.
  VERSION = '0.0.3'
end

require 'struct_packing/base'
require 'struct_packing/util'
require 'struct_packing/packable'
require 'struct_packing/unpackable'
