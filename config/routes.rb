Rails.application.routes.draw do
	root to: 'index#index'
	
	get '/' => 'index#index'

	get '/search' => 'index#search'

	post '/file' => 'index#fileform'
end
