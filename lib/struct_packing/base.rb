
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
    def internal_format
      self.class.internal_format
    end

    # Get field name list of this class.
    def field_names
      self.class.field_names
    end

    # Get field type list of this class.
    def field_types
      self.class.field_types
    end

    # Get Ruby's pack template string for this class.
    def pack_template
      self.class.pack_template
    end
    
    # Common extending methods for Packable and Unpackable.
    #
    # Automatically extend on including StructPacking::Base module.
    module ClassMethods
      
      private

      # TODO temporary initializer for @@struct_internal_format
      def check_vardef
        if not self.class_variable_defined?(:@@struct_internal_format)
          class_eval("@@struct_internal_format = ''")
        end
      end
      
      public

      # Get internal structure format used to pack a object of this class.
      def internal_format
        check_vardef # TODO Find more good way!
        
        Util.internal_format_from( self.class_variable_get(:@@struct_internal_format) )
      end
      
      # Set structure format for this class by string.
      def byte_format=(text)
        check_vardef # TODO Find more good way!
        
        self.class_variable_set(:@@struct_internal_format, text)

        true
      end

      alias :define_struct :byte_format=
      
      # Get field name list of this class.
      def field_names
        internal_format.keys
      end

      # Get field type list of this class.
      def field_types
        internal_format.values
      end

      # Get Ruby's pack template string for this class.
      def pack_template
        check_vardef # TODO Find more good way!

        Util.pack_template_from( self.class_variable_get(:@@struct_internal_format) )
      end

    end
  end
  
end
