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

  def get_file( index )
    file = @files[index]
    get_bytes( file[:offset], file[:size] )
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
    files = {}

    file_entry_size = 3 * 4 + 2 * 2
    number = @header[:file_count]
    source = get_bytes( @header[:file_offset], file_entry_size * number )

    print "- recreating files..."
    progressbar = Progressbar.new( number, display: false )

    offset = 0
    number.times do
      biff = Library::Biff::File.new( source, offset )
      index = biff[:resource][18, 14].join.to_i(2)
      files[index] = biff
      offset = biff.end
      progressbar.tick
    end

    puts " finished."

    files
  end
end