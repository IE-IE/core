class Progressbar
  def initialize( iterations, options = { details: false, display: true } )
    @iterations = iterations.to_f
    @actual = 0
    @human = [0, 100]
    @options = options

    show 
  end

  def show
    if @options[:display]
      print "\r"

      number_of_points = (20 * @percents / 100.0).ceil

      print "["
      number_of_points.times do
        print "#"
      end

      (20 - number_of_points).times do
        print " "
      end

      print "] "
      print " " * (@n.to_s.length - @i.to_s.length)
      print "#{@human[0]} / #{@human[1]}%"
      print " (#{@actual} / #{@iterations.to_i})" if @options[:details]
    end
  end

  def tick
    @actual += 1
    @human[0] = calc
    show

    @human[0]
  end

  private

  def calc
    ((@actual / @iterations) * 100.0).ceil
  end
end

# p = Progressbar.new( 1376, details: false )
# 1376.times do
# 	p.tick
# 	sleep rand(0.01..0.01)
# end