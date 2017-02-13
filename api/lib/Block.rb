class Block
  attr_reader :values,
              :start,
              :end

  def initialize( source, start, pattern )
    @start = start
    @end = nil
    @values = {}
    recreate( source, pattern )

    self
  end

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

  def []( name )
    @values[name]
  end
end