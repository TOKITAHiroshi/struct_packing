module StructPacking

  # Unpackable module provides value assign function from packed byte array.
  # 
  # A class include this module, and call struct defininesg method,
  # A instance's unpack method assign variables from packed object.
  # This module also provide read_struct_data class method
  # which construct object and assign values from packed object.
  module Unpackable
    include StructPacking::Base  
  
    private

    def self.included(base)
      base.send(:include, Base)
      base.extend ClassMethods
    end
  
    # Extending methods for Unpackable class.
    #
    # Automatically extend on including StructPacking::Unpackable module.
    module ClassMethods
      
      # Construct object byte array.
      # 
      # This method is simply do object construct and values assignment.
      # If attribute defined in byte_format, 
      # but object has no attr_setter, do nothing.
      # 
      # TODO: Including class must have default constructor.
      # 
      # * _bytes_ packed structure. (see Packable.pack)
      def unpack(bytes)  
        obj = self.new
        set_values_from_byte_to_object(bytes, obj)
      end
      
      alias :from_data :unpack

      protected
      
      
      # Instantiate and initialize object by value-array.
      def from_values(values)
        obj = self.new
        set_values_from_values_to_object(values, obj)
      end
      
      private

      def set_values_from_byte_to_object(bytes, obj)
        values = bytes.unpack( pack_template )
        set_values_from_values_to_object(values, obj)
      end
     
      # Get field name list of this class.
      def field_names
        internal_format.keys
      end

      def set_values_from_values_to_object(values, obj)
        
        field_names.zip(gather_array_field(values) ).each do |name,value|
          begin
            obj.send(:selfclass).set_field_value(obj, name, value)
          rescue NoMethodError
          end
        end
        obj
      end
     
      def gather_array_field(value_array)
        values = value_array.dup
        
        internal_format.collect do |name, type|

          if type =~ /^struct\s*(\w*)\s*(?:\s*\[(\d+)\s*\])?\s*$/
            struct_name = $1
            arylen = $2
            cls = Util.find_hier_mod(self, struct_name)
            if arylen == nil
              obj = cls.from_values( values[0, cls.send(:num_of_value)] )
              values = values[cls.send(:num_of_value), values.length]
            else
              obj = []
              
              arylen.to_i.times do 
                obj.push( cls.from_values( values[0, cls.send(:num_of_value)] ) )
                values = values[cls.send(:num_of_value), values.length]
              end
            end
            
            obj
          elsif type =~ /.*\[\w*(\d+)\w*\]\w*/
            [0..$1.to_i].to_a.collect { values.shift }
          else
            values.shift
          end
        end
      end
      
      def num_of_value
        
        nums = internal_format.collect do |name, type|
          if type =~ /^struct\s*(\w*)\s*(?:\s*\[(\d+)\s*\])?\s*$/
            struct_name = $1
            arylen = $2
            cls = Util.find_hier_mod(self, struct_name)
            
            if arylen == nil
              cls.num_of_value
            else
              cls.num_of_value * arylen.to_i
            end
          else
            1
          end
        end
        
        nums.inject(0) do |sum, num|
          sum + num
        end
            
      end
      
    end
    
    public
   
    # Set attributes from packed struct byte array.
    #
    # If attribute defined in byte_format, 
    # but object has no attr_setter, do nothing.
    def read_struct_data(bytes)
      self.class.set_values_from_byte_to_object(bytes, self)
    end

  end
end
