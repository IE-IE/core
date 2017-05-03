class String
  # Converts any String written as set of hex bytes to ASCII word.
  # @return [String] ASCII word.
  def to_char
    begin
      [self].pack('H*')
    rescue
      false
    end
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

  # Encodes string in specified way
  #
  # @param params [Hash] Hash of params (use symbols!)
  #   - :table - encoding table from string.yml
  #   - :encoding - encoding to use as a final result (default UTF-8)
  #   - :custom - table for custom chars converting
  # @return encoded string
  def custom_encode( params = {} )
    table = params[:table] || {}
    encoding = params[:encoding] || table['encoding'] || 'UTF-8'
    custom = params[:custom] || table['custom'] || {}

    self.chars.map do |char|
      char = custom[ char.ord ] if custom[ char.ord ]
      char.force_encoding( encoding )
    end.join
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
      return false if self.is_null?
        
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
    when 'signed'
      sign = self.pop
      number = self.reverse.join.to_i(16)
      number = number * (-1) if sign == 'ff'
      number
    when 'number_array'
      self.map do |byte|
        byte.to_i(16)
      end
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

  def is_null?
    # intersection of arrays
    self.include? 'a4' || self.delete_if { |byte| byte == '00' }.empty?
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
  def self.get_bytes( location, offset: nil, number: nil )
    if offset && number
      file = File.open( location, 'rb' )
      file.seek( offset, :SET )
      source = file.readpartial( number )
      bytes = analyze_bytes( source )
      file.close
    else
      bytes = []
      File.open( location, 'rb' ) do |line| 
        bytes << self.analyze_bytes( line )
      end
      bytes.flatten!
    end

    bytes
  end

  private

  def self.analyze_bytes( source )
    bytes = []

    source.each_byte do |b|
      b = b.to_i.to_s(16)
      # make sure every block has two chars
      b = '0' + b if b.length == 1
      bytes << b
    end

    bytes
  end
end

class Dir
  # Finds file, case insensitive (!)
  # Return full path (where joined with found file)
  def self.find_file( where, what )
    unless Dir.exist? where
      LOG.error "Dir.find_file: Directory #{where} doesn't exist."
      return false
    end

    curr_dir = Dir.pwd
    Dir.chdir(where)
    what = what.gsub('\\', '/')
    file = Dir.glob('**/*').find { |f| f.downcase == what.downcase }
    Dir.chdir(curr_dir)

    if file
      File.join(where, file)
    else
      false
    end
  end
end