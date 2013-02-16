
module StructPacking
  module Packable
    private
    
    include Base
    
    def self.included(base)
      base.send("include", Base)
    end
    
    public
    
    def pack()
      values = internal_byte_format.keys.collect do |k|
        begin
          instance_eval { send(k) }
        rescue NoMethodError
          0
        end
      end
      values.flatten!

      types =  internal_byte_format.values
      template = Util.types_to_template( types )

      values.pack( template )
    end
      
  end
end
