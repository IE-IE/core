class BAM::Cycle < Block
  def initialize( source, start )
    super( source, start, TABLES['bam']['cycle'] )
  end
end