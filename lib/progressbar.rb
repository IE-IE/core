class Progressbar
  attr_reader :i
  
  def initialize( max, options = { details: false, display: true } )
    @max = max.to_f
    @actual = 0
    @n = 100
    @options = options

    show 
  end

  def show
    if @option[:display]
      print "\r"

      number_of_points = (20 * @i / 100.0).ceil

      print "["
      number_of_points.times do
        print "#"
      end

      (20 - number_of_points).times do
        print " "
      end

      print "] "
      print " " * (@n.to_s.length - @i.to_s.length)
      print "#{@i} / #{@n}%"
      print " (#{@actual} / #{@max.to_i})" if @options[:details]
    end
  end

  def tick
    @actual += 1
    @i = calc
    show

    @i
  end

  private

  def calc
    ((@actual / @max) * 100.0).ceil
  end
end

# p = Progressbar.new( 1376, details: false )
# 1376.times do
# 	p.tick
# 	sleep rand(0.01..0.01)
# end