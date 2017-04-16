class Api::ResourcesController < ApplicationController
  ALLOWED_TYPES = ['BAM'] 

  def get
    chitin = Memory.read(:chitin)
    resource = chitin.resources.detect { |resource| resource[:name] == params[:name] }

    if resource
      type = resource[:type]
      bytes = chitin.retrieve_file( resource )

      return false unless ALLOWED_TYPES.include? type

      send( type.downcase, bytes )
    end
  end

  private

  def bam( bytes )
    bam = BAM.new( bytes: bytes )
    location = 'tmp/file.png'
    bam.image( frame: 1 ).save( location )

    send_file location, :type => 'image/png', :disposition => 'inline'
  end
end