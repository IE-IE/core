class BAM
  attr_reader :header,
              :pallete

  def initialize( params = {} )
    @bytes =
      if( params[:location] )
        File.get_bytes( params[:location] )
      elsif( params[:bytes] )
        params[:bytes]
      end

    if( @bytes )
      @header = BAM::Header.new( @bytes, 0 )
      @pallete = recreate_pallete
      # @frames = recreate_frames
      # @cycles = recreate_cycles
    end
  end

  private

  def recreate_pallete
    offset = @header[:pallete_offset]
    count = 256
    pallete = []

    count.times do |i|
      pallete << @bytes[ offset + i * 4, 4 ]
    end

    pallete
  end
end