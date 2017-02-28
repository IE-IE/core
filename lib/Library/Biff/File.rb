class Library::Biff::File < Block
  def initialize( source, start )
    super( source, start, TABLES['biff']['header'] )

    @values[:resource].flatten!
  end
end