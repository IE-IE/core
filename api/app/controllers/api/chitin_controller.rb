class Api::ChitinController < ApplicationController
  before_action :load, except: [:set]

  require './lib/chitin'

  def load
    location = @@chitin_location
    @chitin = Chitin.new( location ) if location
  end

  def set
    @@chitin_location = params[:location]
  end

  def filetypes
    result = {}
    result[:filetypes] = @chitin.get_filetypes.sort.to_h
    render json: result
  end

  def files
    result = {}
    result[:files] = @chitin.get_files[ params[:type] ].sort
    render json: result
  end

  def full

  end
end
