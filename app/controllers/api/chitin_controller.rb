class Api::ChitinController < ApplicationController
  include ActionController::Live

   def set
    result = {}
    if File.exist? params[:location]
      result[:success] = true
      Memory.save( :chitin_location, params[:location] )
    else
      result[:success] = false
      result[:error] = "Location doesn't exist"
    end

    render json: result
  end

  def load
    location = Memory.read( :chitin_location )
    if location
      if params['progress']
        begin
          response.headers['Content-Type'] = 'text/event-stream'
          sse = SSE.new( response.stream, retry: 300 )
          sent_progress = 0
          chitin = Chitin.new( location ) do |progress|
            if progress != sent_progress
              sse.write({ progress: progress })
              sent_progress = progress
            end
          end
          Memory.save( :chitin, chitin )
        ensure
          sse.close
        end
      else
        chitin = Chitin.new( location ) {}
        Memory.save( :chitin, chitin )
        result = { success: !!chitin }
        render json: result
      end
    end
  end

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