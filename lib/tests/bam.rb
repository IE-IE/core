require_relative '../app'

bg_location = "/home/mortimer/PlayOnLinux's virtual drives/bgee/drive_c/Program Files/Baldur's Gate/"
chitin_path = bg_location + 'Chitin.key'

chitin = Chitin.new( chitin_path ) {}
resource = chitin.resources.detect { |resource| resource[:name] == 'ISHLD01' }

bam_bytes = chitin.retrieve_file( resource ) 
bam = BAM.new( bytes: bam_bytes )

pp bam.header
pp bam.cycles
pp bam.frames
# pp bam.pallete
# pp bam.frame_table

puts "bytes: " + bam_bytes.size.to_s
bam.frames.each do |frame|
  print frame[:frame_data][1, 31].join.to_i(2)
  print "\n"
end