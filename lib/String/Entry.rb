class String::Entry < Block
  def initialize( source, start, string_offset, ref )
    super( source, start, TABLES['string']['entry'] )

    @ref = ref
    recreate_string( source, string_offset )
  end

  def recreate_string( source, string_offset )
    offset = string_offset + @values[:string_offset]
    length = @values[:string_length]
    string = source[ offset, length ]
    if string
      @values[:string] = string.convert_to('word')
        .custom_encode( table: TABLES['string']['encodings']['bg1']['pl'] )
        .chomp
    end
  end
end