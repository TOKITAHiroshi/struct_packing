
module StructPacking

  public
  class Util

    INT_LENGTH = [1].pack("i").length

    def self.parse_ctype_decl(decl)
      decl =~ /^\s*(unsigned|signed)?\s*(ascii|utf8|byte|char|short|(?:u?int)(?:8|16|32|64)?|(?:big|little)?(?:16|32)|(?:big|little)?\s*(?:float|double)?|long(?:\s*long))\s*(?:\[\s*(\d+)\s*\])?\s*$/

      sign = !("unsigned" == $1)
      template = template_of(sign, $2)
      if $3 != nil
        template += $3
      end
      template
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
      when "int8"
        sign ? 'c' : 'C'
      when "short"
        's'
      when "int16"
        sign ? 's' : 'S'
      when "int"
        sign ? 'i' : 'I'
      when "int32"
        sign ? 'l' : 'L'
      when "long"
        sign ? 'l' : 'L'
      when /long(\s*long)/
        sign ? 'q' : 'Q'
      when "int64"
        sign ? 'q' : 'Q'
      when "uint8"
        'C'
      when "uint16"
        'S'
      when "uint"
        'I'
      when "uint32"
        'L'
      when "uint64"
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
    
    def self.types_to_template(types)
      types.collect {|t| parse_ctype_decl(t)}.join
    end

  end
end
