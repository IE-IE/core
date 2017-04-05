require_relative '../app'

bg_location = "/home/mortimer/PlayOnLinux's virtual drives/bgee/drive_c/Program Files/Baldur's Gate/"
chitin_path = bg_location + 'Chitin.key'

chitin = Chitin.new( chitin_path ) {}
resource = chitin.resources.detect { |resource| resource[:name] == 'ISHLD10' }

bam_bytes = chitin.retrieve_file( resource ) 
bam = BAM.new( bytes: bam_bytes )

pp bam.header
pp bam.cycles
# pp bam.pallete