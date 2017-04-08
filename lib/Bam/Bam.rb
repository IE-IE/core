class BAM < Format
  attr_reader :header,
              :pallete,
              :frames,
              :cycles,
              :frame_table

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
        one: true,
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
      @frame_table = recreate_frame_table
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

  def recreate_frame_table
    # Find highest frame_index+frame_count to determine length of table
    length = 0
    @cycles.each do |cycle|
      sum = cycle[:frame_table_index] + cycle[:frame_count]
      length = sum if sum > length
    end

    
  end
end