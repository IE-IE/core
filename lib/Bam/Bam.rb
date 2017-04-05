class BAM
  def initialize( params = {} )
    @bytes =
      if( params[:location] )
        File.get_bytes( params[:location] )
      elsif( params[:bytes] )
        params[:bytes]
      end

    if( @bytes )
      @header = recreate_header
      @frames = recreate_frames
      @cycles = recreate_cycles
    end
  end
end