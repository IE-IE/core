class Api::LoaderController < ApplicationController
  include ActionController::Live

  def game_location
    game_location = params[:location]
    chitin_location = find_chitin( game_location )
    text_location = find_text( game_location )

    unless chitin_location && text_location
      result = {
        success: false,
        error: "Unable to locate chitin.key or/and dialog.tlk inside specified game directory"
      }
    else
      result = {
        success: true
      }

      Memory.save( :game_location, game_location )
      Memory.save( :chitin_location, chitin_location )
      Memory.save( :text_location, text_location )
    end

    render json: result
  end

  def content_load
    content = params[:content]

    unless ['chitin', 'text'].include? content
      return false
    end

    location = Memory.read( content + '_location' )
    klass = content.capitalize.constantize

    if location
      if params['progress']
        begin
          response.headers['Content-Type'] = 'text/event-stream'
          sse = SSE.new( response.stream, retry: 300 )
          sent_progress = 0
          options = { lazyload: true } if content == 'text'
          content_value = klass.new( location, options ) do |progress|
            if progress != sent_progress
              sse.write({ progress: progress })
              sent_progress = progress
            end
          end
          Memory.save( content, content_value )
        ensure
          sse.close
        end
      else
        content_value = klass.new( location ) {}
        Memory.save( content, content_value )
        result = { success: !!content_value }
        render json: result
      end
    end
  end

  private

  def find_chitin( game_location )
    Dir.find_file( game_location, 'chitin.key' )
  end

  def find_text( game_location )
    Dir.find_file( game_location, 'dialog.tlk' )
  end
end