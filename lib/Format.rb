class Format
  def recreate( klass:, bytes:, progressbar: nil, count: 1, offset: 0, message: nil, params: nil, one: false )

    result = []

    print message[:start] if message && message[:start]

    count.times do |i|
      object = if params
                  klass.new( bytes, offset, params )
               else
                  klass.new( bytes, offset )
               end
      offset = object.end
      result << object

      yield progressbar.tick if progressbar
    end

    puts message[:end] if message && message[:end]

    if one
      result.first
    else
      result
    end
  end
end