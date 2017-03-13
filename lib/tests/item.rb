require_relative '../app'

bg_location = "/home/mortimer/PlayOnLinux's virtual drives/bgee/drive_c/Program Files/Baldur's Gate/"

# Retrieve simple item from biff item file
bif_path = bg_location + 'Data/Items.bif'
bif = Library::Biff.new( bif_path )
file = bif.files[176]
file_content = bif.get_bytes( file[:offset], file[:size] )
item = Item.new( bytes: file_content )
pp item

# retrieve name of item
item_name_ref = item.header[:name_identified]
string = Text.new( bg_location + 'Dialog.tlk' )
item_name = string.entries[ item_name_ref ][:string]
pp item_name

# Save item
# save = item.header.prepare_save( TABLES['item']['header'] )
# Block.save( save, 'newfile' )
# item = Item.new( location: bg_location + 'Override/MISC73.ITM' )
# item.save('misc73-new.itm')