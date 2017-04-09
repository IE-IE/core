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

  # Prepares bytes array to save, based on provided data and pattern.
  #
  # @param pattern (see #initialize)
  # @return [Array] array of bytes, ready to save.
  def prepare_save( pattern )
    bytes = []

    pattern.each do |field|
      # Prepare value
      value = @values[ field['name'].to_sym ]
      if value != nil
        # value exists, so try to convert it
        if field['type']
          value = value.to_hex( field['size'] )
        end
      elsif !value && field['default']
        # use default
        # WARN: default value is NOT convertable! It is raw data to save. It should be only split into pairs of chars (bytes)
        # It should have proper size
        value = field['default'].scan(/../) # scan splits string into pairs of chars
      else
        # don't know what to do, error
        LOG.fatal 'Block.prepare_save: Fatal while preparing field: ' + field['name'] + ', value: ' + value.to_s
        return false
      end

      i = 0
      value.each do |byte|
        bytes[ field['offset'] + i ] = byte
        i += 1
      end
    end

    bytes
  end

  def self.save( bytes, location )
    File.open( location, 'wb' ) do |output|
      output.write bytes.to_bytes
    end
  end

  private 

  # Recreates object from source using pattern.
  #   Saves results as public-visible offsets: @start of block in source, @end of block in source.
  #
  # @param (see #initialize)
  # @return [Integer] - integer of offset.
  def recreate( source, start, pattern )
    @start = start
    pattern.each do |field|
      field['offset'] = field['offset'].to_i(16) if field['offset'].is_a? String
      offset = start + field['offset']
      type = field['type']

      result = source[ offset, field['size'] ]
      result = result.convert_to( type ) if type

      @end = offset + field['size']
      @values[ field['name'].to_sym ] = result
    end

  end
end