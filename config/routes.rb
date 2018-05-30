Rails.application.routes.draw do
	root :controller => 'index', :action => 'index'

	get '/search' => 'incidents#search'
	get '/file' => 'incidents#fileform'

	post '/file' => 'incidents#fileform'
	post '/submit_incident' => 'incidents#submit_incident'

	get '/incident/:id' => 'incidents#see_incident'
end
