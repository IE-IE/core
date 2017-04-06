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
      @header = recreate(
        klass: BAM::Header,
        bytes: @bytes
      )
      @frames = recreate( 
        klass: BAM::Frame, 
        offset: @header[:frame_offset], 
        count: @header[:frame_count], 
        bytes: @bytes
      )
      @cycles = recreate( 
        klass: BAM::Cycle, 
        offset: @frames.last.end, 
        count: @header[:cycle_count], 
        bytes: @bytes
      )
      @pallete = recreate_pallete
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