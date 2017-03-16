class Api::LoaderController < ApplicationController
  include ActionController::Live

  def game_location
    game_location = params[:location]
    chitin_location = find_chitin( game_location )
    dialog_location = find_dialog( game_location )

    unless chitin_location && dialog_location
      result = {
        success: false,
        error: "Unable to locate chitin.key or/and dialog.tlk inside specified game directory"
      }

      Memory.save( :game_location, game_location )
      Memory.save( :chitin_location, chitin_location )
      Memory.save( :dialog_location, dialog_location )
    else
      result = {
        success: true
      }
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

  def dialog_load

  end

  private

  def find_chitin( game_location )
    Dir.find_file( game_location, 'chitin.key' )
  end

  def find_dialog( game_location )
    Dir.find_file( game_location, 'dialog.tlk' )
  end
end