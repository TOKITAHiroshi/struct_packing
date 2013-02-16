
module StructPacking
  module Packable
    private
    
    include Base
    
    def self.included(base)
      base.send("include", Base)
    end
    
    public
    
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
