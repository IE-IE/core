class Chitin::Resource < Block
  def initialize( source, start )
    super( source, start, TABLES['chitin']['resource'] )

    @values[:locator] = @values[:locator].reverse.flatten
    convert_type
  end

  def index
    @values[:locator][18, 14].join.to_i(2)
  end

  def biff_index
  	@values[:locator][0, 12].join.to_i(2)
  end

  private
  
  def convert_type
    type = @values[:type].reverse.join
    types = TABLES['resources']['types']
    selected_type = types.select { |unit| unit['type'] === type }.first
    if selected_type
      @values[:type] = selected_type['extension'].upcase
    else
      @values[:type] = type
    end
  end
end