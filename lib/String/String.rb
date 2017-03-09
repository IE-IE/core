class String
  attr_reader :header,
              :entries

  def initialize( location )
    if File.exist? location
      analyze( location ) { |progress| yield progress }
    else
      puts "File doesn't exist"
      return false
    end
  end

  private

  def analyze( location )
    @bytes = File.get_bytes( location )
    @header = String::Header.new( @bytes, 0 )

    @entries = []
    @header[:entries_count].times do |i|
      @entries << create_entry(i)
    end
  end

  def create_entry( id )
    starting_offset = 18
    entry_size = 26
    offset = id * entry_size + starting_offset

    String::Entry.new( @bytes, offset, @header[:string_offset], id )
  end
end