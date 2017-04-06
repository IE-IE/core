class Format
  def recreate( params = {} )
    params[:count] ||= 1
    params[:offset] ||= 0

    result = []
    offset = params[:offset]

    print params[:message][:start] if params[:message] && params[:message][:start]

    params[:count].times do |i|
      object = if params[:params]
                  params[:klass].new( params[:bytes], offset, params[:params] )
               else
                  params[:klass].new( params[:bytes], offset )
               end
      offset = object.end
      result << object

      yield params[:progressbar].tick if params[:progressbar]
    end

    puts params[:message][:end] if params[:message] && params[:message][:end]

    if params[:one]
      result.first
    else
      result
    end
  end
end