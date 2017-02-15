class Item
  attr_reader :header,
              :extended_headers

  def initialize( params = {} )
    if( params[:location] )
      @bytes = File.get_bytes( params[:location] )
    elsif( params[:bytes] )
      @bytes = params[:bytes]
    end

    if( @bytes )
      @extended_headers = recreate_extended_headers
      @header = recreate_header
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
      extended_headers << Item::ExtendedHeader.new( @bytes, offset, @header )
      offset = extended_headers.last.end
    end

    extended_headers
  end
end