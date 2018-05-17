require 'net/http'
require 'uri'

class IndexController < ApplicationController
  def index
    render 'index'
  end

  def search
    address = params[:address].gsub(/\s/,'+')

    if address.empty?
      redirect_to :action => "index"
    else
      url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{ENV['GEOCODER']}"

      uri = URI.parse(url)
      response = Net::HTTP.get_response uri
      payload = JSON.parse(response.body)

      @lat = payload["results"][0]["geometry"]["location"]["lat"]
      @lng = payload["results"][0]["geometry"]["location"]["lng"]

      render 'search'
    end
  end

  def fileform
    render 'fileform'
  end
end
