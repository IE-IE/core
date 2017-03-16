class Api::LoaderController < ApplicationController
  include ActionController::Live

   def chitin_location
    result = {}
    if File.exist? params[:location]
      result[:success] = true
      Memory.save( :chitin_location, params[:location] )

      set_game_location
      set_dialog_location
    else
      result[:success] = false
      result[:error] = "Location doesn't exist"
    end

    render json: result
  end

  def chitin_load
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

  private

  def set_game_location
    chitin_location = Memory.read( :chitin_location )
    game_location = File.dirname( chitin_location )
    Memory.save( :game_location, game_location )
  end

  def set_dialog_location
    game_location = Memory.read( :game_location )
    dialog_location = Dir.find_file( game_location, 'dialog.tlk' )
    Memory.save( :dialog_location, dialog_location )
  end
end