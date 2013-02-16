
module StructPacking
  module Packable
    private
    
    include Base
    
    def self.included(base)
      base.send("include", Base)
    end
    
    public
    
    def pack()
      bytes = ""
        
      internal_byte_format.each do |name, param|
        begin
          value = instance_eval("#{name.to_s}()")
        rescue NoMethodError => nme
          value = 0
        end
        bytes += Util.pack(param[:type], value)
      end
      bytes
    end
      
  end
end
