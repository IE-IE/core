class Block
  attr_reader :values,
              :start,
              :end

  # Initializes new Block - the ordered and named unit of Infinity Engine.
  #
  # @param source [Array<String>] array of hex bytes.
  # @param start [Integer] offset (index of byte in source array) where the first
  #   item of pattern will be matched / start of block.
  # @param pattern [Array<Hash>] values:
  #   - name [String] - name of field
  #   - offset [String] - hex integer written as string, offset to field in source
  #   - size [Integer] - describes how many bytes belong to that field
  #   - type [String] - if provided, the conversion of field's value will be done. Available types:
  #     - "word" - set of bytes will be converted to ASCII word.
  #     - "array" - each hex byte will be converted to binary byte, and saved as additional array of 8 strings,
  #       whereas each of strings will contain exactly one bit.
  #     - "number" - set of bytes will be reversed (IE uses little endian), joined, and converted to one number in decimal system.
  #     - "boolean" - set of bytes will be joined and converted to Boolean. If one of bytes in set contains non-zero value, the result will be true.
  # @return [Object] Block object.
  def initialize( source, start, pattern )
    @values = {}
    recreate( source, start, pattern )
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
  def recreate( source, start, pattern )
    pattern.each do |field|
      field['offset'] = field['offset'].to_i(16) if field['offset'].is_a? String
      offset = start + field['offset']
      type = field['type']

      result = source[ offset, field['size'] ]
      result = result.convert_to( type ) if type

      @start = offset
      @end = offset + field['size']
      @values[ field['name'].to_sym ] = result
    end
  end
end