class Library::Biff::File < Block
  @@pattern = {
    resource: ['04', 'boolean array'],
    offset: ['04', 'number'],
    size: ['04', 'number'],
    type: ['02', 'number'],
    unknown: ['02']
  }

  def initialize( source, start )
    super( source, start, @@pattern )

    @values[:resource].flatten!
  end
end