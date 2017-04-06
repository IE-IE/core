class Item::ExtendedHeader < Block
  def initialize( source, start, params )
    super( source, start, TABLES['item']['extended_header'] )

    recreate_feature_blocks( source, params[:header] )
  end

  private

  def recreate_feature_blocks( source, header )
    offset = @values[:feature_offset] + header[:feature_offset]
    count = @values[:feature_count]
    @values[:feature_blocks] = []

    count.times do
      feature_block = Item::Feature.new( source, offset )
      @values[:feature_blocks] << feature_block
      offset = feature_block.end
    end
  end
end