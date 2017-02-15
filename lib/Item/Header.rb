class Item::Header < Block
  @@pattern = {
    file_type: ['04', 'word'],
    file_revision: ['04', 'word'],
    name_ref_unidentified: ['04'],
    name_ref_identified: ['04'],
    used_up_item_file: ['08'],
    item_attributes: ['04', 'boolean array'],
    item_type: ['02'],
    useability: ['04', 'boolean array'],
    item_animation: ['02', 'word'],
    min_level: ['02'],
    min_strength: ['02'],
    min_strength_bonus: ['01'],
    kit_usability_1: ['01'],
    min_intelligence: ['01'],
    kit_usability_2: ['01'],
    min_dexterity: ['01'],
    kit_usability_3: ['01'],
    min_wisdom: ['01'],
    kit_usability_4: ['01'],
    min_consitution: ['01'],
    weapon_proficiency: ['01'],
    min_charisma: ['02'],
    price: ['04', 'number'],
    stack: ['02', 'number'],
    inventory_icon: ['08', 'word'],
    lore_to_identify: ['02'],
    ground_icon: ['08', 'word'],
    weight: ['04', 'number'],
    description_ref_unidentified: ['04'],
    description_ref_identified: ['04'],
    description_icon: ['08', 'word'],
    enchantment: ['04', 'number'],
    extended_header_offset: ['04', 'number'],
    extended_header_count: ['02', 'number'],
    feature_table_offset: ['04', 'number'],
    feature_table_equpping_index: ['02'],
    feature_block_count: ['02', 'number']
  }

  def initialize( source, start )
    super( source, start, @@pattern )

    recreate_feature_blocks( source )
  end

  private

  def recreate_feature_blocks( source )
    offset = @values[:feature_table_offset]
    count = @values[:feature_block_count]
    @values[:feature_blocks] = []

    count.to_i.times do
      feature_block = Item::Feature.new( source, offset )
      @values[:feature_blocks] << feature_block
      offset = feature_block.end
    end
  end
end