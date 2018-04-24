Rails.application.routes.draw do
	get '/' => 'index#index'
	get '/search' => 'index#search'
end
