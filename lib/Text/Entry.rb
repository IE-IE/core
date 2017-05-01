class Text::Entry < Block
  def initialize( source, start, ref, text )
    super( source, start, TABLES['text']['entry'] )

    @ref = ref
    recreate_string( text )
  end

  def recreate_string( text )
    starting_offset = text.header[:string_offset]
    offset = starting_offset + @values[:string_offset]
    length = @values[:string_length]

    if text.lazyload
    	string = File.get_bytes( text.location, offset: offset, number: length )
    else
    	string = text.bytes[ offset, length ]
    end

    if string
      @values[:string] = string.convert_to('word')
        .custom_encode( table: TABLES['text']['encodings']['bg1']['pl'] )
        .chomp
    end
  end
end