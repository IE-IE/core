class Text::Header < Block
  def initialize( source, start )
    super( source, start, TABLES['text']['header'] )
  end
end