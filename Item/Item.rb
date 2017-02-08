class Item
  attr_reader :header,
              :extended_headers

  def initialize( params = {} )
    @bytes = []

    if( params[:location] )
      File.open( params[:location], 'rb' ) do |f| 
        f.each_byte do |b|
          b = b.to_i.to_s(16)
          # make sure every block has two chars     
          b = '0' + b if b.length == 1
          @bytes << b
        end 
      end
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