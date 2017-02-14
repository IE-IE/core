class Api::ChitinController < ApplicationController
  require './lib/chitin'
  include ActionController::Live

  def load
    location = @@chitin_location
    if location
      response.headers['Content-Type'] = 'text/event-stream'
      sse = SSE.new(response.stream, retry: 300)
      sent_progress = 0
      @@chitin = Chitin.new( location ) do |progress|
        if progress != sent_progress
          sse.write({ progress: progress })
          sent_progress = progress
        end

        #sse.close if progress == 100
      end
    end
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
    result[:filetypes] = @@chitin.get_filetypes.sort { |x, y| x[:name] <=> y[:name] }
    render json: result
  end

  def files
    result = {}
    result[:files] = @@chitin.get_files[ params[:type] ].sort
    render json: result
  end

  def full
    filetypes = @@chitin.get_filetypes.sort { |x, y| x[:name] <=> y[:name] }
    files = @@chitin.get_files.each { |type, files| files.sort! }
    
    result = {}
    result[:full] = []

    filetypes.each do |filetype|
      filetype[:files] = files[ filetype[:name] ]
      result[:full] << filetype
    end

    render json: result
  end
end