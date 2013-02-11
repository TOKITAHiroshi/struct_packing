
module StructPacking

  public
  class Util
    def self.parse_ctype_decl(decl)
      decl =~ /^\s*(unsigned|signed)?\s*(ascii|utf8|byte|char|short|(?:u?int)(?:8|16|32|64)?|(?:big|little)?(?:16|32)|(?:big|little)?\s*(?:float|double)?|long(?:\s*long))\s*$/
    
      sign = !("unsigned" == $1)
      type = $2
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
    
    
    private
    def self.unpack_primitive(type, bytes)
      bytes.unpack(parse_ctype_decl(type))[0]
    end
    
    def self.pack_primitive(type, value)
      packed = [value].pack( parse_ctype_decl(type) )#.bytes.to_a
    end
    
    public

    def self.unpack(type, bytes)
      if type =~ /(.*)\[(\d*)\]\w*/ 
        size = size_of($1)
        values = []
        (0..$2.to_i-1).each do |i|
          values.push( unpack_primitive($1, bytes[i*size, (i+1)*size] ) )
        end
        values
      else
        unpack_primitive(type, bytes)
      end
    end
    
    def self.pack(type, value)
      if type =~ /(.*)\[(\d*)\]\w*/
        size = size_of($1)
        bytes = ""
        (0..$2.to_i-1).each do |i|
          bytes += pack_primitive($1, value[i])
        end
        bytes
      else
        pack_primitive(type, value)
      end
    end
    
    public
    
    def self.size_of(type)
      if type =~ /(.*)\[(\d*)\]\w*/
        size_of_primitive($1) * $2.to_i
      else
        size_of_primitive(type)
      end
    end
    
    private
    
    def self.size_of_primitive(type)
      format = parse_ctype_decl(type)
    
      if "acC".include?(format)
        1
      elsif "sSnvfge".include?(format)
        2
      elsif "iIlLNVdGE".include?(format)
        4
      elsif "qQ".include?(format)
        8
      else
        -1
      end
    end
    
  end
end