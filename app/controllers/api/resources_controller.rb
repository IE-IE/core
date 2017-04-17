class Api::ResourcesController < ApplicationController
  ALLOWED_TYPES = ['BAM', 'ITM'] 

  def get
    chitin = Memory.read(:chitin)
    resource = chitin.resources.detect { |resource| resource[:name] == params[:name] }

    if resource
      type = resource[:type]
      bytes = chitin.retrieve_file( resource )

      return false unless ALLOWED_TYPES.include? type

      send( type.downcase, bytes, resource )
    end
  end

  private

  def itm( bytes, resource )
    item = Item.new( bytes: bytes )

    result = {
      name: resource[:name],
      type: 'ITM',
      data: {
        header: item.header.values
      }
    }

    render json: result
  end

  def bam( bytes, resource )
    bam = BAM.new( bytes: bytes )
    base_location = 'tmp/resources/' + resource[:name]

    result = {
      name: resource[:name],
      type: 'BAM',
      data: {
        frames: [],
        cycles: nil
      }
    }

    bam.images( frames: :all ).each_with_index do |frame, index|
      location = "#{base_location}-#{index + 1}.png"
      frame.save( location )
      result[:data][:frames] << Base64.strict_encode64( File.open( location, 'rb' ).read )
    end

    render json: result
    
    # send_file "#{base_location}-#{0 + 1}.png", :type => 'image/png', :disposition => 'inline'
  end
end