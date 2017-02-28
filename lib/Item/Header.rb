class Item::Header < Block
  def initialize( source, start )
    super( source, start, TABLES['item']['header'] )

    recreate_feature_blocks( source )
  end

  private

  def recreate_feature_blocks( source )
    offset = @values[:feature_offset]
    count = @values[:feature_count]
    @values[:feature_blocks] = []

    count.to_i.times do
      feature_block = Item::Feature.new( source, offset )
      @values[:feature_blocks] << feature_block
      offset = feature_block.end
    end
  end
end