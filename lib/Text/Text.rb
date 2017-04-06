class Text < Format
  attr_reader :header,
              :entries

  @@cache = {
    location: nil,
    header: nil,
    entries: nil,
  }

  def initialize( location )
    puts "\n"
    puts "==============================="
    puts "Analyzing dialog file..."

    if( @@cache[:location] == location )
      puts "Using cache."
      use_cache
      yield 100 # as progress for loading text
    else
      @location = location
      @bytes = File.get_bytes( @location )

      @header = Text::Header.new( @bytes, 0 )
      @entries = recreate_entries { |progress| yield progress }

      save_cache
    end

    puts "Analyzing dialog file finished."
    puts "==============================="
  end

  def get_entry( id )
  	@entries[id]
  end

  private

  def recreate_entries
    print "- recreating entries..."

    entries = []
    @progressbar = Progressbar.new( @header[:entries_count], display: false )

    @header[:entries_count].times do |i|
      entries << create_entry(i)
      yield @progressbar.tick
    end

    puts " finished."

    entries
  end

  def create_entry( id )
    starting_offset = 18
    entry_size = 26
    offset = id * entry_size + starting_offset

    Text::Entry.new( @bytes, offset, @header[:string_offset], id )
  end

  def use_cache
    @location = @@cache[:location]
    @header = @@cache[:header]
    @entries = @@cache[:entries]
  end

  def save_cache
    @@cache = {}
    @@cache[:location] = @location
    @@cache[:header] = @header
    @@cache[:entries] = @entries
  end
end