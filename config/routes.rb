Rails.application.routes.draw do
	# root to: 'index#index'

	root :controller => 'index', :action => 'index'
	
	# get '/' => 'index#index'

	get '/search' => 'incidents#search'
	get '/file' => 'incidents#fileform'

	post '/file' => 'incidents#fileform'
	post '/submit_incident' => 'incidents#submit_incident'

	get '/incident/:id' => 'incidents#see_incident'

end
