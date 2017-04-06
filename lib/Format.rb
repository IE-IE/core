class Format
  def recreate_multiple( params = {} )
    result = []
    offset = params[:offset]

    print params[:message][:start] if params[:message] && params[:message][:start]

    params[:count].times do |i|
      object = params[:klass].new( params[:bytes], offset )
      offset = object.end
      result << object

      yield params[:progressbar].tick if params[:progressbar]
    end

    puts params[:message][:end] if params[:message] && params[:message][:end]

    result
  end
end