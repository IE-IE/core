require_relative '../progressbar.rb'
require_relative '../string.rb'
require_relative '../tables.rb'

dialog_location = "/home/mortimer/PlayOnLinux's virtual drives/bgee/drive_c/Program Files/Baldur's Gate/Dialog.tlk"

string = String.new(dialog_location)

encoding_table = TABLES['string']['encodings']['bg1']['pl']
10.times do |n|
  puts string.entries[516 + n][:string].custom_encode( table: encoding_table )
end
