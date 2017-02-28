class Chitin::Header < Block
  def initialize( source, start )
    super( source, start, TABLES['chitin']['header'] )
  end
end