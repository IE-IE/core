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
    @bytes = []
    @cache = {}

    puts "\n"
    puts "==============================="
    puts "Analyzing chitin file..."

    if( @@cache[:location] == location )
      puts "Using cache"

      @location = @@cache[:location]
      @header = @@cache[:header]
      @bifs = @@cache[:bifs]
      @resources = @@cache[:resources]
    else
      File.open( location, 'rb' ) do |f| 
        f.each_byte do |b|
          b = b.to_i.to_s(16)
          # make sure every block has two chars
          b = '0' + b if b.length == 1
          @bytes << b
        end 
      end

      @location = location
      @header = recreate_header
      @bifs = recreate_bifs
      @resources = recreate_resources

      @@cache = {}
      @@cache[:location] = @location
      @@cache[:header] = @header
      @@cache[:bifs] = @bifs
      @@cache[:resources] = @resources
    end

    puts "Analyzing chitin file finished."
    puts "==============================="
  end

  def recreate_header
    print "- recreating header..."

    header = Chitin::Header.new( @bytes, 0 )

    puts " finished."

    header
  end

  def recreate_bifs
    bifs = []

    puts "- recreating bifs..."
    progressbar = Progressbar.new( @header[:number_of_bif], details: true )

    offset = @header[:bif_offset]
    @header[:number_of_bif].times do
      bifs << Chitin::Biff.new( @bytes, offset )
      offset = bifs.last.end
      progressbar.tick
    end

    puts "\n--- finished."

    bifs
  end

  def recreate_resources
    resources = []

    puts "- recreating resources..."
    progressbar = Progressbar.new( @header[:number_of_resource], details: true )

    offset = @header[:resource_offset]
    @header[:number_of_resource].times do
      resources << Chitin::Resource.new( @bytes, offset )
      offset = resources.last.end
      progressbar.tick
    end

    puts "\n--- finished."

    resources
  end


  def get_filetypes
    puts "==============================="
    puts "Chitin.get_count in progress..."
    unless @@cache[:count]
      count = Hash.new(0)
      @resources.each { |resource| count[resource[:type]] += 1 }

      @@cache[:count] = count
    end
    puts "Chitin.get_count finished."

    @@cache[:count]
  end

  def get_files
    puts "==============================="
    puts "Chitin.get_files in progress..."
    unless @@cache[:files]
      files = Hash.new([])
      @resources.each { |resource| files[resource[:type]] += [resource[:name]] }

      @@cache[:files] = files
    end
    puts "Chitin.get_files finished."

    @@cache[:files]
  end
end