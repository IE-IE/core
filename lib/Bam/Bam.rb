class BAM < Format
  attr_reader :header,
              :pallete,
              :frames,
              :cycles

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
      @frames = recreate_multiple( 
        klass: BAM::Frame, 
        offset: @header[:frame_offset], 
        count: @header[:frame_count], 
        bytes: @bytes
      )
      @cycles = recreate_multiple( 
        klass: BAM::Cycle, 
        offset: @frames.last.end, 
        count: @header[:cycle_count], 
        bytes: @bytes
      )
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