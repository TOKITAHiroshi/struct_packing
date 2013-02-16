
module StructPacking
  
  private
  
  # Common defines for Packable and Unpackable 
  module Base
    
    private
    
    def self.included(base)
      base.extend ClassMethods
    end
  
    public
    
    # Get structure format string used in packing this object.
    #
    # This method work as just wrapper to same name class-method. 
    def internal_byte_format
      self.class.internal_byte_format
    end
    
    module ClassMethods
      
      private

      def check_vardef
        if not self.class_variable_defined?(:@@byte_format)
          class_eval("@@byte_format = {}")
        end
      end
      
      public

      # Get structure format string used in packing object of this class.
      def internal_byte_format
        check_vardef # TODO Find more good way!
        
        self.class_variable_get(:@@byte_format)
      end
      
      # Set struct format string for this class.
      def byte_format=(arg)
        check_vardef
        
        type_and_name = Util.parse_format_text(arg)
       
        self.class_variable_set(:@@byte_format, type_and_name)

        true
      end
    end
  end
  
end
