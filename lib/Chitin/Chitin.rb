class Chitin < Format
  attr_reader :header,
              :biffs,
              :resources,
              :location

  @@cache = {
    location: nil,
    game_location: nil,
    header: nil,
    biffs: nil,
    resources: nil,
  }

  def initialize( location )
    LOG.info "\n"
    LOG.info "==============================="
    LOG.info "Analyzing chitin file..."

    if( @@cache[:location] == location )
      LOG.info "Using cache."
      use_cache
      yield 100 # as progress for loading chitin
    else
      if File.exist? location
        analyze( location ) { |progress| yield progress }
        save_cache
      else
        LOG.info "File doesn't exist"
        return false
      end
    end

    LOG.info "Analyzing chitin file finished."
    LOG.info "==============================="
  end

  def get_filetypes
    LOG.info "==============================="
    LOG.info "Chitin.get_filetypes in progress..."
    unless @@cache[:filetypes]
      filetypes = Hash.new()

      @resources.each do |resource|
        filetypes[resource[:type]] ||= { name: resource[:type], count: 0 }
        filetypes[resource[:type]][:count] += 1
      end

      @@cache[:filetypes] = filetypes.values.sort { |x, y| x[:name] <=> y[:name] }
    end
    LOG.info "Chitin.get_filetypes finished."
    LOG.info "==============================="

    @@cache[:filetypes]
  end

  def get_files
    LOG.info "==============================="
    LOG.info "Chitin.get_files in progress..."
    if @@cache[:files]
      LOG.info "Using cache."
    else
      files = Hash.new([])
      @resources.each { |resource| files[resource[:type]] += [resource[:name]] }

      @@cache[:files] = files
    end
    LOG.info "Chitin.get_files finished."
    LOG.info "==============================="

    @@cache[:files]
  end

  def biff_of( resource )
  	index = resource.biff_index
  	
  	@biffs[ index ]
  end

  def retrieve_file( resource )
    biff_path = biff_of( resource ).filename
    # Need to use separate function, which converts '\' to '/', and is case-insensitive
    biff_fullpath = Dir.find_file( @game_location, biff_path )
    biff = Library::Biff.new( biff_fullpath )

    biff.get_file( resource.index )
  end

  private

  def analyze( location )
    bytes = File.get_bytes( location )

    @location = location
    @game_location = Pathname.new( @location ).parent.to_s

    @header = recreate(
        klass: Chitin::Header,
        one: true,
        bytes: bytes,
        message: {
          start: '- recreating header...',
          end: ' finished.'
        }
    )

    progressbar_iterations = @header[:resource_count] + @header[:biff_count]
    @progressbar = Progressbar.new( progressbar_iterations, display: false )

    @biffs = recreate( 
        klass: Chitin::Biff, 
        offset: @header[:biff_offset], 
        count: @header[:biff_count], 
        bytes: bytes,
        progressbar: @progressbar,
        message: {
          start: '- recreating biffs...',
          end: ' finished.'
        }
      ) { |progress| yield progress }
    @resources = recreate( 
        klass: Chitin::Resource, 
        offset: @header[:resource_offset], 
        count: @header[:resource_count], 
        bytes: bytes,
        progressbar: @progressbar,
        message: {
          start: '- recreating resource...',
          end: ' finished.'
        }
      ) { |progress| yield progress }
  end

  def use_cache
    @location = @@cache[:location]
    @game_location = @@cache[:game_location]
    @header = @@cache[:header]
    @biffs = @@cache[:biffs]
    @resources = @@cache[:resources]
  end

  def save_cache
    @@cache = {}
    @@cache[:location] = @location
    @@cache[:game_location] = @game_location
    @@cache[:header] = @header
    @@cache[:biffs] = @biffs
    @@cache[:resources] = @resources
  end
end