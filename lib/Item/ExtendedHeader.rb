class Item::ExtendedHeader < Block
  @@pattern = {
    ability_type: ['01', 'number'],
    force_identify: ['01', 'boolean'],
    location: ['01', 'number'],
    alternative_dice_sides: ['01'],
    equipt_icon: ['08', 'word'],
    target: ['01', 'number'],
    target_count: ['01'],
    effect_radius: ['02', 'number'],
    projectile_type: ['01', 'number'],
    alternative_dice_thrown: ['01'],
    speed_factor: ['01', 'number'],
    alternative_damage_bonus: ['01'],
    thac0_bonus: ['02', 'number'],
    dice_sides: ['01', 'number'],
    primary_type: ['01'],
    throws: ['01', 'number'],
    secondary_type: ['01', 'number'],
    damage_bonus: ['02', 'number'],
    damage_type: ['02', 'number'],
    feature_block_count: ['02', 'number'],
    feature_table_offset: ['02', 'number'],
    charges: ['02', 'number'],
    charge_depletion: ['02', 'number'],
    flags: ['04', 'boolean array'],
    projectile_animation: ['02'],
    melee_animation: ['06'],
    bow_arrow_qualifier: ['02', 'boolean'],
    crossbow_bolt_qualifier: ['02', 'boolean'],
    misc_projectile_qualifier: ['02', 'boolean']
  }

  def initialize( source, start, header )
    super( source, start, @@pattern )

    recreate_feature_blocks( source, header )
  end

  private

  def recreate_feature_blocks( source, header )
    offset = header.values[:feature_blocks].last.end
    count = @values[:feature_block_count]
    @values[:feature_blocks] = []

    count.times do
      feature_block = Item::Feature.new( source, offset )
      @values[:feature_blocks] << feature_block
      offset = feature_block.end
    end
  end
end