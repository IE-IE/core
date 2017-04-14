class Api::ResourcesController < ApplicationController
  ALLOWED_TYPES = ['BAM'] 

  def get
    chitin = Memory.read(:chitin)
    resource = chitin.resources.detect { |resource| resource[:name] == params[:name] }

    if resource
      type = resource[:type]
      bytes = chitin.retrieve_file( resource )

      redirect_to action: type.downcase, bytes: bytes if ALLOWED_TYPES.include? type
    end
  end

  def bam
    bam = BAM.new( bytes: params[:bytes] )
  end
end