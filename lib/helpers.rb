class String
  # Converts any String written as set of hex bytes to ASCII word.
  # @return [String] ASCII word.
  def to_char
    [self].pack('H*')
  end
end

class Array
  # Converts set of bytes to desired type.
  #
  # @param type (see Block#initialize)
  # @return value depending on desired type.
  # @note Since this method is used mostly in Block, see {Block#initialize}
  def convert_to( type )
    case type
    when 'word'
      self.delete_if { |byte| byte == '00' }.join.to_char
    when 'array'
      self.map do |byte|
        boolean_string = byte.to_i(16).to_s(2)
        # fill to correct number of digits (8 digits for sure)
        boolean_string = "0" * (8 - boolean_string.length) + boolean_string
        boolean_string.split('')
      end
    when 'number'
      self.reverse.join.to_i(16)
    when 'boolean'
      number = self.reverse.join.to_i(16)
      number == 0 ? false : true
    end
  end
end

class File
  # Gets bytes from file
  #
  # @param location [String] path to file.
  # @return [Array<String>] array of strings, whereas each string is bytes written in hexadecimal system.
  def self.get_bytes( location )
    bytes = []
    self.open( location, 'rb' ) do |f| 
      f.each_byte do |b|
        b = b.to_i.to_s(16)
        # make sure every block has two chars
        b = '0' + b if b.length == 1
        bytes << b
      end 
    end

    bytes
  end
end