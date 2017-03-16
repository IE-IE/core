Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do

    get '/load/chitin/location', to: 'loader#chitin_location'
    get '/load/chitin', to: 'loader#chitin_load'

    get '/chitin/filetypes', to: 'chitin#filetypes'
    get '/chitin/files/:type', to: 'chitin#files'
    get '/chitin/full', to: 'chitin#full'

  end
end
