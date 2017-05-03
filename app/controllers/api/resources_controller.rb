class Api::ResourcesController < ApplicationController
  ALLOWED_TYPES = ['BAM', 'ITM'] 

  def get( name: nil, full: false )
  	name ||= params[:name]
  	full ||= params[:full]

    chitin = Memory.read(:chitin)
    resource = chitin.resources.detect { |resource| resource[:name] == name }

    if resource
      type = resource[:type]
      bytes = chitin.retrieve_file( resource )

      return false unless ALLOWED_TYPES.include? type

      send( type.downcase, bytes, resource, full: full )
    end
  end

  private

  def itm( bytes, resource, full: false )
    item = Item.new( bytes: bytes )

    result = {
      name: resource[:name],
      type: 'ITM',
      data: {
        header: item.header.values
      }
    }

    if full
    	result[:relationships] = {
    		graphics: [],
    		texts: []
    	}
    end

    render json: result
  end

  def bam( bytes, resource, full: false, no_render: false )
    bam = BAM.new( bytes: bytes )
    base_location = 'tmp/resources/' + resource[:name]

    result = {
      name: resource[:name],
      type: 'BAM',
      data: {
        frames: [],
        cycles: []
      }
    }

    bam.images( frames: :all ).each_with_index do |frame, index|
      location = "#{base_location}-#{index + 1}.png"
      frame.save( location )
      result[:data][:frames] << Base64.strict_encode64( File.open( location, 'rb' ).read )
    end

    bam.cycles.each do |cycle|
      result[:data][:cycles] << { frames: bam.frame_table[ cycle[:frame_table_index], cycle[:frame_count] ] }
    end

    if no_render
    	result
    else
    	render json: result
	end
	    
    # send_file "#{base_location}-#{0 + 1}.png", :type => 'image/png', :disposition => 'inline'
  end
end