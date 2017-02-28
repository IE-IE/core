class Chitin::Resource < Block
  @@pattern = {
    name: ['08', 'word'],
    type: ['02'],
    locator: ['04', 'boolean array']
  }

  def initialize( source, start )
    super( source, start, @@pattern )

    @values[:locator].flatten!
    convert_type
  end

  private
  
  def convert_type
    type = @values[:type].reverse.join
    if @@type_pattern[ type ]
      @values[:type] = @@type_pattern[ type ].upcase
    else
      @values[:type] = type
    end
  end
end