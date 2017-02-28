class Item::Feature < Block
  def initialize( source, start )
    super( source, start, TABLES['item']['feature'] )
  end
end