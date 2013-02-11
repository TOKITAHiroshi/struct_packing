
module StructPacking
  
  private
  
  module Base
    
    def self.included(base)
      base.extend ClassMethods
      if not base.class_variable_defined?(:@@byte_format)
        base.class_eval("@@byte_format = {}")
      end
    end
  
    def byte_format
      self.class.byte_format
    end
    
    module ClassMethods
      
      private
  
      def append_define(name, type)
        count = 0
        byte_format.values.collect {|v| count += v[:size] }
  
        size = Util.size_of( type )
        
        byte_format[name] = {:type=>type, :start=>count, :size=>size}
      end
      
      def parse_format_text(text)
        params = {}
        text.split(/[\n;]/).each do |line|
          line.gsub!(/^\s*/,'')
          line.gsub!(/\s*$/,'')
  
          idx = line.rindex(' ')
          type = line[0..idx-1]
          name = line[idx+1..line.length]
          
          params[name.to_sym] = type
        end
        
        params
      end
      
      public
      
      def byte_format
        self.class_variable_get(:@@byte_format)
      end
      
      def byte_format=(arg)
        
        if arg.is_a?(String)
          params = parse_format_text(arg)
        else
          params = arg   
        end
        
        params.keys.each do |f|
          append_define(f, params[f])
        end   
      end
    end
  end
  
end