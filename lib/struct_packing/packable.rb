
module StructPacking
  
  # Packable module provides object-packing function.
  # 
  # A class include this module, and call struct defining method,
  # pack method returns defined byte-array-form of that class's instance.
  #
  # == SYNOPSIS:
  #  class PackableOStruct < OpenStruct
  #    include StructPacking::Packable
  #    self.byte_format = "int foo; char bar; byte[1] baz;"
  #  end
  #
  #  obj = PackableOStruct.new
  #  obj.foo = 1
  #  obj.bar = 2
  #  obj.baz = [8]
  #  packed_bytes = obj.pack # => "\x01\x00\x00\x00\x02\b"
  module Packable
    private
    
    include Base
    
    def self.included(base)
      base.send(:include, Base)
    end
    
    public

    # Pack this object to byte array.
    #
    # If attribute defined in byte_format, 
    # but object has no attr_getter, treat as the attribute is zero.
    def pack()
      values = field_names.collect do |n|
        begin
          instance_eval { send(n) }
        rescue NoMethodError
          0
        end
      end
      values.flatten!

      values.pack( pack_template )
    end
      
  end
end
