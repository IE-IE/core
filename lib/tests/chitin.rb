require_relative '../app'
require 'benchmark'

bg_location = "/home/mortimer/PlayOnLinux's virtual drives/bgee/drive_c/Program Files/Baldur's Gate/"
chitin_path = bg_location + 'Chitin.key'
chitin = nil

Benchmark.bm(15) do |x|
  x.report('chitin:') { chitin = Chitin.new( chitin_path ) {} }
  x.report('files:') { chitin.get_files }
  x.report('filetypes:') { chitin.get_filetypes }
end