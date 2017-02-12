Rails.application.routes.draw do
  namespace :api do
    get '/chitin/filetypes', to: 'chitin#filetypes'
    get '/chitin/files/:type', to: 'chitin#files'
    get '/chitin/full', to: 'chitin#full'
    get '/chitin/set', to: 'chitin#set'
  end
end
