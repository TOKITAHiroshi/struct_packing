
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

    def field_names
      self.class.field_names
    end

    def field_types
      self.class.field_types
    end

    def pack_template
      self.class.pack_template
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

      def field_names
        internal_byte_format.keys
      end

      def field_types
        internal_byte_format.values
      end

      def pack_template
        Util.types_to_template( field_types )
      end

    end
  end
  
end
