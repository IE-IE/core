class Format
  def recreate_multiple( klass, offset, count, bytes )
    result = []

    count.times do |i|
      object = klass.new( bytes, offset )
      offset = object.end
      result << object
    end

    result
  end
end