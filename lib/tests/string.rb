require_relative '../app'

dialog_location = "/home/mortimer/PlayOnLinux's virtual drives/bgee/drive_c/Program Files/Baldur's Gate/Dialog.tlk"

string = String.new( dialog_location )

2.times do |n|
  puts string.entries[516 + n][:string]
end

string = String.new( dialog_location )

2.times do |n|
  puts string.entries[516 + n][:string]
end