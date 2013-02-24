
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
    
    def value_or_zero(&block)
      begin
        instance_eval &block
      rescue
        0
      end
    end
    
    protected
    
    def struct_values
      internal_format.collect do |name, type|
        if type =~ /^struct\s*\w*\s*(?:\s*\[(\d+)\s*\])?\s*$/
          arynum = $1
          if $1 == nil
            value_or_zero { send(name).struct_values }
          else
            (0..(arynum.to_i-1)).each.collect do |i|
              value_or_zero { send(name)[i].struct_values }
            end
          end
        else
          value_or_zero { send(name) }
        end
      end
    end

    public
  
    # Pack this object to byte array.
    #
    # If attribute defined in byte_format, 
    # but object has no attr_getter, treat as the attribute is zero.
    def pack()
      values = struct_values
      values.flatten!
      values.pack( pack_template )
    end
      
  end
end
