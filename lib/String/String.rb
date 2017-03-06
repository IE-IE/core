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
    bytes = File.get_bytes( location )
    @header = String::Header.new( bytes, 0 )
  end
end