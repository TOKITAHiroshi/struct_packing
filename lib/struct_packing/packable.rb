
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
        
      byte_format.each do |name, param|
        if not respond_to?("#{name.to_s}=".to_sym)
          instance_eval("def #{name.to_s}=(arg) ; @#{name.to_s} = arg; end")
          instance_eval("def #{name.to_s} ; @#{name.to_s} ; end")
        end
        
        databytes = bytes[param[:start],param[:size]]
        type = param[:type]
        tmp = instance_eval("Util.pack( \"#{type}\", self.#{name.to_s} )")

        bytes += tmp
      end
      bytes
    end
      
  end
end
