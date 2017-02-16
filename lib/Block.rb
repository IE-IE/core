class Block
  attr_reader :values,
              :start,
              :end

  # Initializes new Block - the ordered and named unit of Infinity Engine.
  #
  # @param source [Array<String>] array of hex bytes.
  # @param start [Integer] offset (index of byte in source array) where the first
  #   item of pattern will be matched / start of block.
  # @param pattern [Hash] key: name of field to save; value: [size, type]
  #   size [String] - hex Integer (written as String), describes how many bytes belong to that field
  #   type [String] - if provided, the conversion of field's value will be done. Available types:
  #     - "word" - set of bytes will be converted to ASCII word.
  #     - "boolean array" - each hex byte will be converted to binary byte, and saved as additional array of 8 strings,
  #       whereas each of strings will contain exactly one bit.
  #     - "number" - set of bytes will be reversed (IE uses little endian), joined, and converted to one number in decimal system.
  #     - "boolean" - set of bytes will be joined and converted to Boolean. If one of bytes in set contains non-zero value, the result will be true.
  # @return [Object] Block object.
  def initialize( source, start, pattern )
    @start = start
    @end = nil
    @values = {}
    recreate( source, pattern )
  end

  # Returns value of some field.
  #
  # @param name [String] name of field.
  # @return value of field, nil if field doesn't exist.
  def []( name )
    @values[name]
  end

  private 

  # Recreates object from source using pattern.
  #   Saves results as public-visible offsets: @start of block in source, @end of block in source.
  #
  # @param (see #initialize)
  # @return [Integer] - integer of offset.
  def recreate( source, pattern )
    offset = @start
    pattern.each do |name, val|
      size = val[0].to_i(16)
      type = val[1]
      result = source[offset, size]
      result = result.convert_to( type ) if type
      @values[name] = result
      offset += size
    end
    @end = offset
  end
end