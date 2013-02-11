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

      def unpack_to_hash(bytes)
        data = {}
        byte_format.each do |name, param|
          databytes = bytes[param[:start],param[:size]]
          type = param[:type]
            
          data[name] = Util.unpack(type,databytes)
        end
        data
      end
      
      def set_values_from_byte_to_object(bytes, obj)
        h = unpack_to_hash(bytes)
        
        h.keys.each do |name|
          begin
            obj.instance_eval("self.#{name} = #{h[name]}")
          rescue NoMethodError => nme
            p nme
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
