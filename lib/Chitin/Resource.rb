class Chitin::Resource < Block
  @@pattern = {
    name: ['08', 'word'],
    type: ['02'],
    locator: ['04', 'boolean array']
  }

  @@type_pattern = {
  	'0001' => 'bmp',
  	'0002' => 'mve',
  	'0004' => 'wav',
  	'0005' => 'wfx',
  	'0006' => 'plt',
  	'03e8' => 'bam',
  	'03e9' => 'wed',
  	'03ea' => 'chu',
  	'03eb' => 'tis',
  	'03ec' => 'mos',
  	'03ed' => 'itm',
  	'03ee' => 'spl',
  	'03ef' => 'bcs',
  	'03f0' => 'ids',
  	'03f1' => 'cre',
  	'03f2' => 'are',
  	'03f3' => 'dlg',
  	'03f4' => '2da',
  	'03f5' => 'gam',
  	'03f6' => 'sto',
  	'03f7' => 'wmp',
  	'03f8' => 'chr',
  	'03f9' => 'bs',
  	'03fa' => 'chr',
  	'03fb' => 'vvc',
  	'03fc' => 'vef',
  	'03fd' => 'pro',
  	'03fe' => 'bio',
  	'0400' => 'fnt',
  	'0401' => 'wbm',
  	'0402' => 'gui',
  	'0403' => 'sql',
  	'0404' => 'pvrz',
  	'044c' => 'ba',
  	'0802' => 'ini',
  	'0803' => 'src'
  }

  def initialize( source, start )
    super( source, start, @@pattern )

    @values[:locator].flatten!
    convert_type
  end

  private
  
  def convert_type
    type = @values[:type].reverse.join
    if @@type_pattern[ type ]
      @values[:type] = @@type_pattern[ type ].upcase
    else
      @values[:type] = type
    end
  end
end