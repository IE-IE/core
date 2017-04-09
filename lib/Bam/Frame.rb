class BAM::Frame < Block
  attr_reader :data

  def initialize( source, start )
    super( source, start, TABLES['bam']['frame'] )
    @values[:frame_data] = @values[:frame_data].reverse.flatten

    @data = recreate_data( source )
  end

  # First bit == 0 -> compressed
  def compressed?
    @values[:frame_data][0] == '0'
  end

  def decompress!( transparency_index )
    if !compressed?
      return
    end

    newdata = []

    @data.each_with_index do |val, index|
      # If previous byte was transparency, skip
      # It means, that this byte describes number of transparencies
      if index > 0 && @data[index - 1] == transparency_index
        next
      end

      newdata << val

      if val == transparency_index
        # Lets see next byte
        count = @data[index + 1] || 0
        # And add appropriate number of transparencies
        # Doesn't add anything if count == 0
        newdata.push( *[transparency_index] * count )

        # Set transparency count byte as USED
        @data[index + 1] = -1
      end
    end

    # Cut whatever is exceeding
    @data = newdata[0, @values[:width] * @values[:height]]

    # Set byte to decompressed
    @values[:frame_data][0] = '1'
  end

  private

  def recreate_data( source )
    offset = @values[:frame_data][1, 31].join.to_i(2)
    size = @values[:width] * @values[:height]

    source[ offset, size ].map { |val| val.to_i(16) }
  end
end