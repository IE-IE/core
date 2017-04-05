class BAM::Frame < Block
  def initialize( source, start )
    super( source, start, TABLES['bam']['frame'] )
  end
end