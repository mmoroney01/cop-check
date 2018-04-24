class IndexController < ApplicationController
	def index
		render 'index'
	end

	def search
		@lat = 41.8781
		@lng = -87.6298

		render 'search'
	end
end
