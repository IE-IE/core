class String
  # Converts any String written as set of hex bytes to ASCII word.
  # @return [String] ASCII word.
  def to_char
    [self].pack('H*')
  end

  def to_hex( size = nil )
    bytes = self.unpack('H*').first.scan(/../).map do |byte|
      "0" * (2 - byte.length) + byte
    end

    if size
      (size - bytes.length).times do 
        bytes.unshift('00')
      end
    end

    bytes
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

  def to_hex( size = nil )
    bytes = []
    self.each do |sequence|
      byte = sequence.join.to_i(2).to_s(16)
      bytes << "0" * (2 - byte.length) + byte
    end

    bytes
  end

  # INFO: Use on result of to_hex!
  def to_bytes
    self.map { |byte| byte.to_i(16) }.pack('C*')
  end

  # Appends elements at specified offset
  def append( array2, offset = self.size )
  	i = 0
  	array2.each do |val|
  		self[ offset + i ] = val
  		i += 1
  	end

  	self
  end
end

class Integer
  def to_hex( size = nil )
    bytes = self.to_s(16)
    bytes = '0' + bytes if bytes.length % 2 != 0
    
    bytes = bytes.scan(/../)
    if size
      (size - bytes.size).times do 
        bytes.unshift('00')
      end
    end

    bytes.reverse
  end
end

class TrueClass
  def to_hex( size = nil )
    bytes = '10'
    bytes += '00' * (size - 1) if size

    bytes.scan(/../)
  end
end

class FalseClass
  def to_hex( size = nil )
    bytes = '00'
    bytes += '00' * (size - 1) if size

    bytes.scan(/../)
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