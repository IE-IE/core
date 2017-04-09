class BAM::Frame < Block
  attr_reader :data

  def initialize( source, start )
    super( source, start, TABLES['bam']['frame'] )
    @values[:frame_data] = @values[:frame_data].reverse.flatten

    @data = recreate_data( source )
  end

  # First bit == 0 -> compressed
  def compressed?
    @values[:frame_data][1] == '0'
  end

  def decompress!( transparency_index )
    if compressed?
      newdata = []

      @data.each_with_index do |val, index|
        # If previous byte was transparency, skip
        # It means, that this byte describes number of transparencies
        if index > 0 && @data[index - 1] == transparency_index
          next
        end

        if val == transparency_index
          # Lets see next byte
          count = @data[index + 1]
          # And add appropriate number of transparencies
          newdata.push( *[transparency_index] * count )
        end

        puts count + 1 if count

        newdata << val
      end

      # Cut whatever is exceeding

      @data = newdata[0, @values[:width] * @values[:height]]
    end
  end

  private

  def recreate_data( source )
    offset = @values[:frame_data][1, 31].join.to_i(2)
    size = @values[:width] * @values[:height]

    source[ offset, size ].map { |val| val.to_i(16) }
  end
end