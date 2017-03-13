require_relative '../app'

bg_location = "/home/mortimer/PlayOnLinux's virtual drives/bgee/drive_c/Program Files/Baldur's Gate/"
chitin_path = bg_location + 'Chitin.key'

chitin = Chitin.new( chitin_path ) {}
resource = chitin.resources[5600]
print resource[:type]
print chitin.retrieve_file( resource )[0, 4] # get only four bytes to compare type