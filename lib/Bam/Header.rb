class BAM::Header < Block
  def initialize( source, start )
    super( source, start, TABLES['bam']['header'] )
  end
end