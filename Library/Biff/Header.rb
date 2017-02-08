class Library::Biff::Header < Block
  @@pattern = {
    signature: ['04', 'word'],
    version: ['04', 'word'],
    number_of_file: ['04', 'number'],
    number_of_tileset: ['04', 'number'],
    file_offset: ['04', 'number'],
  }

  def initialize( source, start )
    super( source, start, @@pattern )
  end
end