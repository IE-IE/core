require_relative '../app'

bg_location = "/home/mortimer/PlayOnLinux's virtual drives/bgee/drive_c/Program Files/Baldur's Gate/"

chitin_path = bg_location + 'Chitin.key'
chitin = Chitin.new( chitin_path ) {}
pp chitin.get_filetypes
pp chitin.get_files
