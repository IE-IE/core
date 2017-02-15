class Library::Biff < Library
  attr_reader :header,
              :files

  def initialize( filename )
    super( filename )

    puts "\n"
    puts "==============================="
    puts "Analyzing #{filename}..."
    analyze
    puts "Analyzing #{filename} finished."
    puts "==============================="
  end

  private

  def analyze
    @header = recreate_header
    @files = recreate_files
  end

  def recreate_header
    print "- recreating header..."

    header_size = 5 * 4
    source = get_bytes( 0, header_size )
    header = Library::Biff::Header.new( source, 0 )

    puts " finished."

    header
  end

  def recreate_files
    files = []

    file_entry_size = 3 * 4 + 2 * 2
    number = @header[:number_of_file]
    source = get_bytes( @header[:file_offset], file_entry_size * number )

    print "- recreating files..."
    progressbar = Progressbar.new( number, details: true )

    offset = 0
    number.times do
      files << Library::Biff::File.new( source, offset )
      offset = files.last.end
      progressbar.tick
    end

    puts " finished."

    files
  end
end