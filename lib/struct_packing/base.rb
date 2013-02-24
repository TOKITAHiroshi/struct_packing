
module StructPacking
  
  private
  
  # Common defines for Packable and Unpackable 
  module Base
    
    private
    
    def self.included(base)
      base.extend ClassMethods
      base.attr_mapped_struct
      
      base.instance_eval { @selfclass = base }
      base.instance_eval { def selfclass ; @selfclass ; end }
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
    
  
    def get_field_value(name)
      selfclass.get_field_value(self, name)
    end

    def set_field_value(name, value)
      selfclass.set_field_value(self, name, value)
    end
    
    # Get structure format string used in packing this object.
    #
    # This method work as just wrapper to same name class-method. 
    def internal_format
      selfclass.send(:internal_format)
    end
    
    # Get field name list of this class.
    def field_names
      selfclass.field_names
    end

    # Get field type list of this class.
    def field_types
      selfclass.field_types
    end
    
    public

    # Get Ruby's pack template string for this class.
    def pack_template
      selfclass.pack_template
    end
    
    # Common extending methods for Packable and Unpackable.
    #
    # Automatically extend on including StructPacking::Base module.
    module ClassMethods
      
      private
      
      def self.extended(base)
        base.class_eval do
          begin
            @struct_field_getter = superclass.class_eval { @struct_field_getter }
          rescue
            @struct_field_getter = nil
          end
          begin
            @struct_field_setter = superclass.class_eval { @struct_field_setter }
          rescue
            @struct_field_setter = nil
          end
          begin
            @struct_internal_format = superclass.class_eval { @struct_internal_format }
            if @struct_internal_format == nil
              @struct_internal_format = ""
            end
          rescue
            @struct_internal_format = ""
          end
        end
      end
      
      protected

      # Get internal structure format used to pack a object of this class.
      def internal_format
        Util.internal_format_from( @struct_internal_format)
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
        @struct_internal_format = text

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
        if self.to_s =~ /^.*<(.*):0x.*/
          clsname = $1
        else
          clsname = self.to_s
        end
        
        Util.pack_template_from( @struct_internal_format, clsname )
      end
    
      # Call getter procedure to get field of target object.
      def get_field_value(obj, name)
        begin
          @struct_field_getter.call(obj, name)
        rescue
          0
        end
      end
            
      # Call setter procedure to set value to the field of target object.
      def set_field_value(obj, name, value)
        begin
          @struct_field_setter.call(obj, name, value)
        rescue
        end
      end

      # Set gettter procedure.
      def set_field_getter(&block)
        @struct_field_getter = block
      end
      
      # Set settter procedure.
      def set_field_setter(&block)
        @struct_field_setter = block
      end
      
      # Declare this struct as accessible by hash-style-access(access by [] operator).
      def hash_mapped_struct
        set_field_getter {|obj, name| obj[name.to_sym] }
        set_field_setter {|obj, name, value| obj[name.to_sym] = value }
      end
      
      # Declare this struct as accessible by attr-style-access(access by {name}= operator).
      # This is default behavior.
      def attr_mapped_struct
        set_field_getter {|obj, name| obj.send(name) }
        set_field_setter {|obj, name, value| obj.send("#{name}=", value) }
      end

      alias :define_struct :byte_format=
      
    end
  end
  
end
