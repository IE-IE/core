class Library
  attr_reader :filename,
              :file

  def initialize( filename )
    @filename = filename
  end

  def get_bytes( offset, number )
    bytes = []
    
    file = File.open( @filename, 'rb' )
    file.seek( offset, :SET )
    file.readpartial( number ).each_byte do |b|
      b = b.to_i.to_s(16)
      # make sure every block has two chars
      b = '0' + b if b.length == 1
      bytes << b
    end

    bytes
  end
end