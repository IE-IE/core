class Chitin::Biff < Block
  attr_reader :filename

  def initialize( source, start )
    super( source, start, TABLES['chitin']['biff'] )

    @values[:location].flatten!

    recreate_filename( source )
  end

  private

  def recreate_filename( source )
    @filename = source[ @values[:filename_offset], @values[:filename_length] ].convert_to( 'word' )
  end
end