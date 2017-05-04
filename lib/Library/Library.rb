class Library
  attr_reader :filename,
              :file

  def initialize( filename )
    @filename = filename
  end

  def get_bytes( offset, number )
    File.get_bytes( @filename, offset: offset, number: number )
  end
end