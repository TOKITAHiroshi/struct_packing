
module StructPacking
  
  private
  
  # Common defines for Packable and Unpackable 
  module Base
    
    private
    
    def self.included(base)
      base.extend ClassMethods
    end
    
    protected

    def selfclass
      if defined?(self.class.selfclass)
        self.class.selfclass
      else
        eign = (class << self; self ; end)
        eign.selfclass
      end
    end
    
    # Get structure format string used in packing this object.
    #
    # This method work as just wrapper to same name class-method. 
    def internal_format
      self.class.__send__(:internal_format)
    end
    
    # Get field name list of this class.
    def field_names
      self.class.field_names
    end

    # Get field type list of this class.
    def field_types
      self.class.field_types
    end
    
    public

    # Get Ruby's pack template string for this class.
    def pack_template
      self.class.pack_template
    end
    
    # Common extending methods for Packable and Unpackable.
    #
    # Automatically extend on including StructPacking::Base module.
    module ClassMethods
      
      protected

      # Get internal structure format used to pack a object of this class.
      def internal_format
        if class_variable_defined?(:@@struct_internal_format)
          
          Util.internal_format_from( self.class_variable_get(:@@struct_internal_format) )
        else
          {}
        end
      end
  
      protected
      
      def num_of_value
        
        nums = internal_format.collect do |name, type|
          if type =~ /^struct\s*(\w*)\s*(?:\s*\[(\d+)\s*\])?\s*$/
            struct_name = $1
            arylen = $2
            cls = Util.find_hier_mod(self, struct_name)
            
            if arylen == nil
              cls.num_of_value
            else
              cls.num_of_value * arylen.to_i
            end
          else
            1
          end
        end
        
        nums.inject(0) do |sum, num|
          sum + num
        end
            
      end
      

      def gather_array_field(value_array)
        values = value_array.dup
        
        internal_format.collect do |name, type|

          if type =~ /^struct\s*(\w*)\s*(?:\s*\[(\d+)\s*\])?\s*$/
            struct_name = $1
            arylen = $2
            cls = Util.find_hier_mod(self, struct_name)
            if arylen == nil
              obj = cls.from_values( values[0, cls.num_of_value] )
              values = values[cls.num_of_value, values.length]
            else
              obj = []
              
              arylen.to_i.times do 
                obj.push( cls.from_values( values[0, cls.num_of_value] ) )
                values = values[cls.num_of_value, values.length]
              end
            end
            
            obj
          elsif type =~ /.*\[\w*(\d+)\w*\]\w*/
            [0..$1.to_i].to_a.collect { values.shift }
          else
            values.shift
          end
        end
      end
      
      public
      
      # Set structure format for this class by string.
      def byte_format=(text)
        self.class_variable_set(:@@struct_internal_format, text)

        true
      end

      protected

      # Get field name list of this class.
      def field_names
        internal_format.keys
      end

      protected
      
      # Get field type list of this class.
      def field_types
        internal_format.values
      end

      public
      
      # Get Ruby's pack template string for this class.
      def pack_template
        if class_variable_defined?(:@@struct_internal_format)
          Util.pack_template_from( self.class_variable_get(:@@struct_internal_format), self )
        else
          ""
        end
      end

      alias :define_struct :byte_format=
      
    end
  end
  
end
