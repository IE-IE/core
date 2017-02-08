class API < Controller
  @@chitin_location = "/home/mortimer/PlayOnLinux's virtual drives/bgee/drive_c/Program Files/Baldur's Gate - Enhanced Edition/chitin.key"

  def chitin
    chitin = Chitin.new( @@chitin_location )

    @result = {}

    if( @params['type'] )
      @result[:type] = @params['type']
      @result[:files] = chitin.get_files[ @params['type'] ].sort
      @render = 'chitin/files'
    else
      @result[:filetypes] = chitin.get_filetypes.sort.to_h
      @render = 'chitin/filetypes'
    end 
  end

  def chitin_full
    chitin = Chitin.new( @@chitin_location )

    @filetypes = chitin.get_filetypes.sort.to_h
    @files = chitin.get_files.each { |type, files| files.sort! }
    @render = 'chitin/full'
  end

  def chitin_set
    @@chitin_location = @params['location']
    @result = {}
    if File.exist? @@chitin_location
      @result[:success] = true
    else
      @result[:success] = false
      @result[:error] = "Location doesn't exist"
    end
    @render = 'chitin/set'
  end
end