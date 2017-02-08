class Library::Biff::Tileset < Block
  @@pattern = {
    resource: ['04'],
    offset: ['04', 'number'],
    count: ['04', 'number'],
    size: ['04', 'number'],
    type: ['02', 'number'],
    unknown: ['02']
  }

  def initialize( source, start )
    super( source, start, @@pattern )
  end
end