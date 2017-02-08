class Chitin::Header < Block
  @@pattern = {
    signature: ['04', 'word'],
    version: ['04', 'word'],
    number_of_bif: ['04', 'number'],
    number_of_resource: ['04', 'number'],
    bif_offset: ['04', 'number'],
    resource_offset: ['04', 'number']
  }

  def initialize( source, start )
    super( source, start, @@pattern )
  end
end