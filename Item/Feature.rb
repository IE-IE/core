class Item::Feature < Block
  @@pattern = {
    feature: ['02'],
    target: ['01', 'number'],
    power: ['01'],
    param1: ['04'],
    param2: ['04'],
    time_mode: ['01', 'number'],
    resistance: ['01'],
    duration: ['04', 'number'],
    propability1: ['01', 'number'],
    propability2: ['01', 'number'],
    resource: ['08'],
    dice_thrown: ['04'],
    dice_sides: ['04'],
    saving_throw_type: ['04'],
    saving_throw_bonus: ['04'],
    special: ['04']
  }

  def initialize( source, start )
    super( source, start, @@pattern )
  end
end