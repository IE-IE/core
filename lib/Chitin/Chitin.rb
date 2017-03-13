class Chitin
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
    puts "\n"
    puts "==============================="
    puts "Analyzing chitin file..."

    if( @@cache[:location] == location )
      puts "Using cache."
      use_cache
      yield 100 # as progress for loading chitin
    else
      if File.exist? location
        analyze( location ) { |progress| yield progress }
        save_cache
      else
        puts "File doesn't exist"
        return false
      end
    end

    puts "Analyzing chitin file finished."
    puts "==============================="
  end

  def get_filetypes
    puts "==============================="
    puts "Chitin.get_filetypes in progress..."
    unless @@cache[:filetypes]
      filetypes = Hash.new()

      @resources.each do |resource|
        filetypes[resource[:type]] ||= { name: resource[:type], count: 0 }
        filetypes[resource[:type]][:count] += 1
      end

      @@cache[:filetypes] = filetypes.values.sort { |x, y| x[:name] <=> y[:name] }
    end
    puts "Chitin.get_filetypes finished."
    puts "==============================="

    @@cache[:filetypes]
  end

  def get_files
    puts "==============================="
    puts "Chitin.get_files in progress..."
    if @@cache[:files]
      puts "Using cache."
    else
      files = Hash.new([])
      @resources.each { |resource| files[resource[:type]] += [resource[:name]] }

      @@cache[:files] = files
    end
    puts "Chitin.get_files finished."
    puts "==============================="

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
    @header = recreate_header( bytes )

    progressbar_iterations = @header[:resource_count] + @header[:biff_count]
    @progressbar = Progressbar.new( progressbar_iterations, display: false )

    @biffs = recreate_biffs( bytes ) { |progress| yield progress }
    @resources = recreate_resources( bytes ) { |progress| yield progress }
  end

  def recreate_header( bytes )
    print "- recreating header..."

    header = Chitin::Header.new( bytes, 0 )

    puts " finished."

    header
  end

  def recreate_biffs( bytes )
    biffs = []

    print "- recreating biffs..."

    offset = @header[:biff_offset]
    @header[:biff_count].times do
      biff = Chitin::Biff.new( bytes, offset )
      biffs << biff
      offset = biff.end
      yield @progressbar.tick
    end

    puts " finished."

    biffs
  end

  def recreate_resources( bytes )
    resources = []

    print "- recreating resources..."

    offset = @header[:resource_offset]
    @header[:resource_count].times do
      resource = Chitin::Resource.new( bytes, offset )
      resources << resource
      offset = resource.end
      yield @progressbar.tick
    end

    puts " finished."

    resources
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