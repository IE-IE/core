class Item::ExtendedHeader < Block
  def initialize( source, start, header )
    super( source, start, TABLES['item']['extended_header'] )

    recreate_feature_blocks( source, header )
  end

  private

  def recreate_feature_blocks( source, header )
    offset = header.values[:feature_blocks].last.end
    count = @values[:feature_count]
    @values[:feature_blocks] = []

    count.times do
      feature_block = Item::Feature.new( source, offset )
      @values[:feature_blocks] << feature_block
      offset = feature_block.end
    end
  end
end