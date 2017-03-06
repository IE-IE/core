class String::Header < Block
  def initialize( source, start )
    super( source, start, TABLES['string']['header'] )
  end
end