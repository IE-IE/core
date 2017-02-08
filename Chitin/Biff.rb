class Chitin::Biff < Block
  attr_reader :filename

  @@pattern = {
    length: ['04', 'number'],
    filename_offset: ['04', 'number'],
    filename_length: ['02', 'number'],
    location: ['02', 'boolean array']
  }

  def initialize( source, start )
    super( source, start, @@pattern )

    @values[:location].flatten!

    recreate_filename( source )
  end

  def recreate_filename( source )
    @filename = source[ @values[:filename_offset], @values[:filename_length] ].convert_to( 'word' )
  end
end