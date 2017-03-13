require_relative '../app'

bg_location = "/home/mortimer/PlayOnLinux's virtual drives/bgee/drive_c/Program Files/Baldur's Gate/"

# Cache inside Chitin test
# chitin_path = bg_location + 'chitin.key'
# Chitin.new( chitin_path )
# Chitin.new( chitin_path )

# bif_path = bg_location + 'data/ITEMS.BIF'
# bif = Library::Biff.new( bif_path )
# file = bif.files[25]
# file_content = bif.get_bytes( file[:offset], file[:size] )
# item = Item.new( bytes: file_content )

chitin_path = bg_location + 'Chitin.key'
chitin = Chitin.new( chitin_path ) {}
pp chitin.get_filetypes
pp chitin.get_files
