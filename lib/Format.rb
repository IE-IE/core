class Format
  def recreate_multiple( params = {} )
    result = []

    params[:count].times do |i|
      object = params[:klass].new( params[:bytes], params[:offset] )
      offset = object.end
      result << object

      yield params[:progressbar].tick if params[:progressbar]
    end

    result
  end
end