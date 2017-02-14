# WARNING: It's only draft, it's NOT usable
class Cache
  attr_reader :cache

  def initialize( dir )
    Dir.mkdir( dir ) unless Dir.exists? dir
    @dir = dir

    @cached_files = {}
    scan_dir 

    @cache = {}
  end

  def store( key, data )
    @cache[key] = data

    compiled = @cache[key] # Here goes serialization

    begin
      name = rand(1..999999)
    end while @cached_files.values.include? name

    file = File.open( File.join( @dir, name.to_s ), 'w' )
    file.puts key
    file.puts compiled
  end

  def get( key )

  end

  private

  def scan_dir
    path = File.join( @dir, '*' )
    files = Dir.glob( path )

    files.each do |filepath|
      file = File.open( filepath, 'r' )
      key = file.readline
      file.close

      @cached_files[key] = filepath
    end
  end
end