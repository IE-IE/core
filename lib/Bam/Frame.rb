class BAM::Frame < Block
  def initialize( source, start )
    super( source, start, TABLES['bam']['frame'] )
    @values[:frame_data] = @values[:frame_data].reverse.flatten
  end
end