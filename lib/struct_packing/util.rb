
module StructPacking

  public

  # internal C-like_structure_declaration
  class Util

    private
    
    def self.struct_template(type, arraylen, mod=nil)
      type =~ /struct\s*(\w*)\s*/

      if arraylen != ""
        find_hier_mod(mod, $1).pack_template * arraylen.to_i
      else
        find_hier_mod(mod, $1).pack_template
      end
      
    end

    def self.parse_ctype_decl(decl, mod=nil)
      decl =~ /^\s*(unsigned|signed)?\s*(ascii|utf8|byte|char|short|(?:u?int)(?:(?:8|16|32|64)_t)?|(?:big|little)?(?:16|32)|(?:big|little)?\s*(?:float|double)?|long(?:\s*long)|struct\s*\w*)\s*([\s\*]*)\s*(?:\[\s*(\d+)\s*\])?\s*$/

      sign = !("unsigned" == $1) #sign modifier
      type = $2
      ptr = $3
      arraylen = $4

      if arraylen == nil or arraylen == "1"
        arraylen = ""
      end
      
      if ptr != nil and ptr != "" #pointer operator
        'P' + arraylen
      elsif "struct" == type[0..5]
        struct_template(type, arraylen, mod)
      else
        template_of(sign, type) + arraylen
      end
    end

    def self.template_of(sign, type)
      case type
      when "ascii"
        'a'
      when "utf8"
        'U'
      when "byte"
        'C'
      when "char"
        'c'
      when "int8_t"
        sign ? 'c' : 'C'
      when "short"
        's'
      when "int16_t"
        sign ? 's' : 'S'
      when "int"
        sign ? 'i' : 'I'
      when "int32_t"
        sign ? 'l' : 'L'
      when "long"
        sign ? 'l' : 'L'
      when /long(\s*long)/
        sign ? 'q' : 'Q'
      when "int64_t"
        sign ? 'q' : 'Q'
      when "uint8_t"
        'C'
      when "uint16_t"
        'S'
      when "uint"
        'I'
      when "uint32_t"
        'L'
      when "uint64_t"
        'Q'
      when "big16"
        'n'
      when "big"
        'N'
      when "big32"
        'N'
      when "little16"
        'v'
      when "little"
        'V'
      when "little32"
        'V'
      when "float"
        'f'
      when /big\s*float/
        'g'
      when /little\s*float/
        'e'
      when "double"
        'd'
      when /big\s*double/
        'G'
      when /little\s*double/
        'E'
      end      
    end

    def self.types_to_template(types, mod=nil)
      types.collect {|t| parse_ctype_decl(t,mod)}.join
    end

    
    def self.find_hier_mod(context_mod, sym)
      nesthier = context_mod.to_s.split("::")
    
      parent = Kernel
      mods = nesthier.collect {|m| x = parent.const_get(m); parent = x; x }
      mods.unshift Kernel
    
      finded = mods.reverse.collect {|m| m.const_defined?(sym) ? m.const_get(sym) : nil }
      targetmod = finded.select {|f| f != nil }.first
    
      if targetmod == nil
        raise NameError
      end
      targetmod
    end
  
    
    public
    # Parse declaration string into pack template.
    def self.pack_template_from(text,mod=nil)
      internal = internal_format_from(text)
      types_to_template(internal.values,mod)
    end

    # Parse declaration string into internal format.
    # Internal format is {:name=>"type", ...}
    def self.internal_format_from(text)
      params = {}
      text.split(/[\n;]/).each do |line|
        line.gsub!(/^\s*/,'')
        line.gsub!(/\s*$/,'')

        idx = line.rindex(' ')
        type = line[0..idx-1]
        name = line[idx+1..line.length]

        if name =~ /(.*)\[\w*(\d+)\w*\]\w*/
          type += "[#{$2}]"
          name = $1
        end
 
        params[name.to_sym] = type
      end
      
      params
    end
  end
end
