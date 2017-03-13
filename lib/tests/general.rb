require_relative '../app'

bg_location = "/home/mortimer/PlayOnLinux's virtual drives/bgee/drive_c/Program Files/Baldur's Gate/"

# retrieve types and filenames from resources (example of BOW)
# chitin_path = bg_location + 'chitin.key'
# chitin = Chitin.new( chitin_path )
# pp chitin.resources.reject { |resource| resource[:name] !~ /BOW/}

# retrieve all files
# chitin_path = bg_location + 'chitin.key'
# chitin = Chitin.new( chitin_path )
# file_types = {}
# bifs = {}

# chitin.resources.each do |resource|
# 	locator = resource[:locator][20, 12].join.to_i(2)
# 	if chitin.bifs[ locator ]
# 		bif_path = chitin.bifs[ locator ].filename
# 		bifs[bif_path] = Library::Biff.new( bg_location + bif_path ) unless bifs[bif_path]
# 		bif = bifs[bif_path]
# 		bif_files = bif.files
# 		id = resource[:locator][0, 14].join.to_i(2)
# 		found_file = bif_files.reject { |file| file[:resource][0, 14].join.to_i(2) != id }.first
# 		if found_file
# 			file_type = bif.get_bytes( found_file[:offset], 4).join.to_char
# 			file_types[file_type] = resource[:type]
# 		end
# 	end
# end

# pp file_types 

# Cache inside Chitin test
# chitin_path = bg_location + 'chitin.key'
# Chitin.new( chitin_path )
# Chitin.new( chitin_path )

# Cache class test
# require './cache.rb'
# cache = Cache.new( '.cache' )

# bif_path = bg_location + 'data/ITEMS.BIF'
# bif = Library::Biff.new( bif_path )
# file = bif.files[25]
# file_content = bif.get_bytes( file[:offset], file[:size] )
# item = Item.new( bytes: file_content )

# cache.store( 'item', item )

# chitin_path = bg_location + 'chitin.key'
# chitin = Chitin.new( chitin_path )
# pp chitin.get_count
# pp chitin.get_filenames
