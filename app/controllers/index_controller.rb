class IndexController < ApplicationController
	def index
		render 'index'
	end

	def search
		p params['search']

		render 'search'
	end
end
