require 'net/http'
require 'uri'

class IndexController < ApplicationController
  def index
    render 'index'
  end

  def search
    address = params[:address].gsub(/\s/,'+')

    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key="

    uri = URI.parse(url)
    response = Net::HTTP.get_response uri
    payload = JSON.parse(response.body)

    @lat = payload["results"][0]["geometry"]["location"]["lat"]
    @lng = payload["results"][0]["geometry"]["location"]["lng"]

    render 'search'
  end
end
