require_relative '../progressbar.rb'
require_relative '../string.rb'
require_relative '../tables.rb'

dialog_location = "/home/mortimer/PlayOnLinux's virtual drives/bgee/drive_c/Program Files/Baldur's Gate - Enhanced Edition/dialog.tlk"

string = String.new(dialog_location)

# Detect encoding
string = string.entries[1110][:string]
p string
p string.force_encoding("UTF-8")
p string.bytes
# pp string.encode("UTF-8", "ATM")
# encodings = ["UTF-8", "Windows-1250", "Windows-1251", "Windows-1252", "ISO-8859-2", "ISO-8859-1", "ISO-8859-4", "ISO-8859-13", "ISO-8859-15", "ISO-8859-16"]

# encodings.each do |encoding|
#   p string.encode("UTF-8", encoding)
# end
