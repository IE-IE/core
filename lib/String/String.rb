class String
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
    else
      @location = location
      @bytes = File.get_bytes( @location )

      @header = String::Header.new( @bytes, 0 )
      @entries = recreate_entries

      save_cache
    end

    puts "Analyzing dialog file finished."
    puts "==============================="
  end

  private

  def recreate_entries
    print "- recreating entries..."

    entries = []
    @header[:entries_count].times do |i|
      entries << create_entry(i)
    end

    puts " finished."

    entries
  end

  def create_entry( id )
    starting_offset = 18
    entry_size = 26
    offset = id * entry_size + starting_offset

    String::Entry.new( @bytes, offset, @header[:string_offset], id )
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