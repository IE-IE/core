class Item < Format
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
      @header = recreate(
        klass: Item::Header,
        one: true,
        bytes: @bytes
      )
      @extended_headers = recreate( 
        klass: Item::ExtendedHeader, 
        offset: @header[:extended_header_offset], 
        count: @header[:extended_header_count], 
        bytes: @bytes,
        params: {
          header: @header
        }
      )
    end
  end

  def save( location )
    bytes = @header.prepare_save( TABLES['item']['header'] )

    # Casting feature blocks
    feature_blocks_bytes = []
    @header[:feature_blocks].each do |feature_block|
      feature_blocks_bytes += feature_block.prepare_save( TABLES['item']['feature'] )
    end
    bytes = bytes.append( feature_blocks_bytes, @header[:feature_offset] )

    # Extended headers
    extended_headers_bytes = []
    @extended_headers.each do |extended_header|
      extended_headers_bytes += extended_header.prepare_save( TABLES['item']['extended_header'] )
    end
    bytes = bytes.append( extended_headers_bytes, @header[:extended_header_offset] )

    # Extended headers feature blocks
    @extended_headers.each do |extended_header|
      feature_blocks_bytes = []
      extended_header[:feature_blocks].each do |feature_block|
        feature_blocks_bytes += feature_block.prepare_save( TABLES['item']['feature'])
      end
      bytes = bytes.append( feature_blocks_bytes, @header[:feature_offset] + extended_header[:feature_offset] )
    end

    Block.save( bytes, location )
  end
end