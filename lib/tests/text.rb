require_relative '../app'

dialog_location = "/home/mortimer/PlayOnLinux's virtual drives/bgee/drive_c/Program Files/Baldur's Gate/Dialog.tlk"

text = Text.new( dialog_location )

2.times do |n|
  puts text.entries[516 + n][:string]
end

text = Text.new( dialog_location )

2.times do |n|
  puts text.entries[516 + n][:string]
end