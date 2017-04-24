require_relative '../app'

bg_location = "/home/mortimer/PlayOnLinux's virtual drives/bgee/drive_c/Program Files/Baldur's Gate/"
chitin_path = bg_location + 'Chitin.key'

chitin = Chitin.new( chitin_path ) {}
resource = chitin.resources.detect { |resource| resource[:name] == 'STAF01' }
file = chitin.retrieve_file( resource )
pp Item.new( bytes: file )