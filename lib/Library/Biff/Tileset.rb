class Library::Biff::Tileset < Block
  def initialize( source, start )
    super( source, start, TABLES['biff']['header'] )
  end
end