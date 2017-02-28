class Chitin::Resource < Block
  def initialize( source, start )
    super( source, start, TABLES['chitin']['resource'] )

    @values[:locator].flatten!
    convert_type
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