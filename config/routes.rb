Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do

    get '/load/game/location', to: 'loader#game_location'
    get '/load/chitin', to: 'loader#content_load', content: 'chitin'
    get '/load/text', to: 'loader#content_load', content: 'text'

    get '/chitin/filetypes', to: 'chitin#filetypes'
    get '/chitin/files/:type', to: 'chitin#files'
    get '/chitin/full', to: 'chitin#full'

    get '/texts/get/:id', to: 'text#string'

    get '/resources/get/:name', to: 'resources#get'

    # get '/resources/bam', to: 'resources#bam'
  end
end
