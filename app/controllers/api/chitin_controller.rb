class Api::ChitinController < ApplicationController
  before_action :load, except: [:set]

  require './lib/chitin'

  def load
    location = @@chitin_location
    @chitin = Chitin.new( location ) if location
  end

  def set
    @@chitin_location = params[:location]

    result = {}
    if File.exist? @@chitin_location
      result[:success] = true
    else
      result[:success] = false
      result[:error] = "Location doesn't exist"
    end

    render json: result
  end

  def filetypes
    result = {}
    result[:filetypes] = @chitin.get_filetypes.sort { |x, y| x[:name] <=> y[:name] }
    render json: result
  end

  def files
    result = {}
    result[:files] = @chitin.get_files[ params[:type] ].sort
    render json: result
  end

  def full
    filetypes = @chitin.get_filetypes.sort.to_h
    files = @chitin.get_files.each { |type, files| files.sort! }
    
  end
end