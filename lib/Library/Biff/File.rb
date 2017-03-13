class Library::Biff::File < Block
  def initialize( source, start )
    super( source, start, TABLES['biff']['file'] )

    @values[:resource] = @values[:resource].reverse.flatten
  end
end