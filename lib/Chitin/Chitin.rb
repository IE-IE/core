class Chitin
  attr_reader :header,
              :bifs,
              :resources,
              :location

  @@cache = {
    location: nil,
    header: nil,
    bifs: nil,
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
      analyze( location ) { |progress| yield progress }
      save_cache
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

      @@cache[:filetypes] = filetypes.values
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

  private

  def analyze( location )
    bytes = File.get_bytes( location )

    @location = location
    @header = recreate_header

    progressbar_iterations = @header[:number_of_resource] + @header[:number_of_bif]
    @progressbar = Progressbar.new( progressbar_iterations, display: false )

    @bifs = recreate_bifs { |progress| yield progress }
    @resources = recreate_resources { |progress| yield progress }
  end

  def recreate_header
    print "- recreating header..."

    header = Chitin::Header.new( @bytes, 0 )

    puts " finished."

    header
  end

  def recreate_bifs
    bifs = []

    print "- recreating bifs..."

    offset = @header[:bif_offset]
    @header[:number_of_bif].times do
      bif = Chitin::Biff.new( @bytes, offset )
      bifs << bif
      offset = bif.end
      yield @progressbar.tick
    end

    puts " finished."

    bifs
  end

  def recreate_resources
    resources = []

    print "- recreating resources..."

    offset = @header[:resource_offset]
    @header[:number_of_resource].times do
      resource = Chitin::Resource.new( @bytes, offset )
      resources << resource
      offset = resource.end
      yield @progressbar.tick
    end

    puts " finished."

    resources
  end

  def use_cache
    @location = @@cache[:location]
    @header = @@cache[:header]
    @bifs = @@cache[:bifs]
    @resources = @@cache[:resources]
  end

  def save_cache
    @@cache = {}
    @@cache[:location] = @location
    @@cache[:header] = @header
    @@cache[:bifs] = @bifs
    @@cache[:resources] = @resources
  end
end