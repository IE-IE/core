class Item
  attr_reader :header,
              :extended_headers

  def initialize( params = {} )
    @bytes =
      if( params[:location] )
        File.get_bytes( params[:location] )
      elsif( params[:bytes] )
        params[:bytes]
      end

    if( @bytes )
      @header = recreate_header
      @extended_headers = recreate_extended_headers
    end
  end

  def recreate_header
    Item::Header.new( @bytes, 0 )
  end

  def recreate_extended_headers
    extended_headers = []
    offset = @header[:extended_header_offset]
    count = @header[:extended_header_count]

    count.times do |i|
      extended_header = Item::ExtendedHeader.new( @bytes, offset, @header )
      extended_headers << extended_header
      offset = extended_header.end
    end

    extended_headers
  end

  def save( location )
    bytes = @header.prepare_save( TABLES['item']['header'] )
    bytes.flatten!

    # Casting feature blocks
    feature_blocks_bytes = []
    @header[:feature_blocks].each do |feature_block|
      feature_blocks_bytes += feature_block.prepare_save( TABLES['item']['feature'] )
    end
    bytes[ @header[:feature_offset] ] = feature_blocks_bytes
    bytes.flatten!

    # Extended headers
    extended_headers_bytes = []
    @extended_headers.each do |extended_header|
      extended_headers_bytes += extended_header.prepare_save( TABLES['item']['extended_header'] )
    end
    bytes[ @header[:extended_header_offset] ] = extended_headers_bytes
    bytes.flatten!

    # Extended headers feature blocks
    @extended_headers.each do |extended_header|
      feature_blocks_bytes = []
      extended_header[:feature_blocks].each do |feature_block|
        feature_blocks_bytes += feature_block.prepare_save( TABLES['item']['feature'])
      end
      bytes[ @header[:feature_offset] + extended_header[:feature_offset] ] = feature_blocks_bytes
      bytes.flatten!
    end

    # Remove all nils which came from flattenning
    bytes = bytes.compact

    Block.save( bytes, location )
  end
end