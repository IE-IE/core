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

  # Frame can be id of frame or BAM::Frame
  def image_of( frame )
    if frame.is_a? Integer
      frame = @frames[frame]
    elsif !frame.is_a? BAM::Frame
      puts 'Oh, no no. You want the image of what? Seriously!'
      return
    end

    png = ChunkyPNG::Image.new( frame[:width], frame[:height], ChunkyPNG::Color::TRANSPARENT )
    row = 0
    column = 0

    # Decompress
    frame.decompress!( @pallete[256] ) if frame.compressed?

    frame.data.each do |index|
      color = @pallete[index]

      # Apparently we (didn't) hit transparency!
      if index != @pallete[256]
        png[column, row] = ChunkyPNG::Color.rgb( color[2].to_i(16), color[1].to_i(16), color[0].to_i(16) )
      end

      column += 1
      if column == frame[:width]
        column = 0
        row += 1
      end
    end

    png.save( 'filename.png' )
  end

  private

  def recreate_pallete
    offset = @header[:pallete_offset]
    count = 256
    pallete = []
    transparency = 0

    count.times do |i|
      color = @bytes[ offset + i * 4, 4 ]
      transparency = i if color == ["00", "ff", "00", "00"]
      pallete << color
    end

    pallete[256] = transparency

    pallete
  end

  def recreate_frame_table
    # Find highest frame_index+frame_count to determine size of table
    size = 0
    @cycles.each do |cycle|
      sum = cycle[:frame_table_index] + cycle[:frame_count]
      size = sum if sum > size
    end

    bytes = @bytes[ @header[:frame_table_offset], size ]
    bytes.convert_to 'number_array'
  end
end