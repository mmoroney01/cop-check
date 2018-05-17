Rails.application.routes.draw do
	root to: 'index#index'
	
	get '/' => 'index#index'
	get '/search' => 'index#search'
	get '/file' => 'index#fileform'

	post '/file' => 'index#fileform'
	post '/submit_incident' => 'index#submit_incident'

end
