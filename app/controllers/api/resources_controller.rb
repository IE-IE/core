class Api::ResourcesController < ApplicationController
  ALLOWED_TYPES = ['BAM', 'ITM'] 

  def get( name: nil, full: false, no_render: false )
    name ||= params[:name]
    full ||= !!params[:full]
    no_render ||= !!params[:no_render]

    chitin = Memory.read(:chitin)
    resource = chitin.resources.detect { |resource| resource[:name] == name }

    if resource
      type = resource[:type]
      bytes = chitin.retrieve_file( resource )

      return false unless ALLOWED_TYPES.include? type

      result = send( type.downcase, bytes, resource, full: full )
    end

    if no_render
      result
    else
      render json: result
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

      graphics = [
        item.header[:icon_inventory],
        item.header[:icon_ground],
        item.header[:icon_description]
      ]

      graphics.each do |graphic|
        next unless graphic
        result[:relationships][:graphics] << get( name: graphic, no_render: true )
      end

      texts = [
        item.header[:name_unidentified],
        item.header[:name_identified],
        item.header[:description_unidentified],
        item.header[:description_identified]
      ]

      texts.each do |text|
        next unless text
        entry = Memory.read(:text).get_entry( text )
        next unless entry
        result[:relationships][:texts] << {
          id: text,
          string: entry[:string]
        }
      end
    end

    result
  end

  def bam( bytes, resource, full: false )
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

    result

    # send_file "#{base_location}-#{0 + 1}.png", :type => 'image/png', :disposition => 'inline'
  end
end