module StructPacking

  module Unpackable
    include StructPacking::Base  
  
    private

    def self.included(base)
      base.send("include", Base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      
      def unpack(bytes)  
        obj = self.new
        set_values_from_byte_to_object(bytes, obj)
      end
      
      alias :from_data :unpack

      private

      def set_values_from_byte_to_object(bytes, obj)
        
        values = bytes.unpack( pack_template )
        value_fields = internal_byte_format.map do |name, format|
          if format =~ /.*\[\w*(\d+)\w*\]\w*/
            [name, [0..$1.to_i].to_a.collect { values.shift } ]
          else
            [name, values.shift]
          end
        end

        value_fields.each do |tuple|
          begin
            obj.instance_eval {
              send("#{tuple[0]}=", tuple[1])
            }
          rescue NoMethodError
          end
        end
        obj
      end
      
    end
    
    public
    
    def read_struct_data(bytes)
      self.class.set_values_from_byte_to_object(bytes, self)
    end

  end
end
