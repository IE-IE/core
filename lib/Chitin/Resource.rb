class Chitin::Resource < Block
  @@pattern = {
    name: ['08', 'word'],
    type: ['02'],
    locator: ['04', 'boolean array']
  }

  @@type_pattern = {
    '0404' => 'PVRZ',
    'f203' => 'ARE',
    'ec03' => 'MOS',
    'e903' => 'WED',
    'eb03' => 'TIS',
    '0100' => 'BMP',
    'e803' => 'BAM',
    '0400' => 'WAV',
    'f403' => '2DA',
    'f003' => 'IDS',
    'f503' => 'GAM',
    'f103' => 'CRE',
    'f703' => 'WMP',
    'ed03' => 'ITM',
    'fb03' => 'VVC',
    'f803' => 'EFF',
    'f603' => 'STO',
    'ef03' => 'BCS',
    '0204' => 'GUI',
    '0304' => 'SQL',
    '0904' => 'LUA',
    'ea03' => 'CHU',
    'ee03' => 'SPL',
    'fd03' => 'PRO',
    'fa03' => 'CHR',
    '0004' => 'FNT',
    'f303' => 'DLG',
    '0600' => 'PLT',
    '0208' => 'INI',
    '0a04' => 'TTF',
    '0504' => 'GLSL',
    '0804' => 'MENU',
    '0200' => 'MVE'
  }

  def initialize( source, start )
    super( source, start, @@pattern )

    @values[:locator].flatten!
    convert_type
  end

  private
  
  def convert_type
    type = @values[:type].join
    if @@type_pattern[ type ]
      @values[:type] = @@type_pattern[ type ]
    else
      @values[:type] = type
    end
  end
end