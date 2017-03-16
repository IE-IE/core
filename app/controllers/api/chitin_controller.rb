class Api::ChitinController < ApplicationController
  def filetypes
    result = {}
    result[:filetypes] = Memory.read(:chitin).get_filetypes
    render json: result
  end

  def files
    result = {}
    result[:files] = Memory.read(:chitin).get_files[ params[:type] ].sort
    render json: result
  end

  def full
    filetypes = Memory.read(:chitin).get_filetypes
    files = Memory.read(:chitin).get_files.each { |type, files| files.sort! }
    
    result = {}
    result[:full] = []

    filetypes.each do |filetype|
      filetype[:files] = files[ filetype[:name] ]
      result[:full] << filetype
    end

    render json: result
  end
end