class IndexController < ApplicationController
	def index
		render 'index'
	end

	def search
		@foo = Incident.first

		p @foo

		render 'search'
	end
end
