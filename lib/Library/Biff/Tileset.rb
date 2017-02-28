class Library::Biff::Tileset < Block
  def initialize( source, start )
    super( source, start, TABLES['biff']['tileset'] )
  end
end