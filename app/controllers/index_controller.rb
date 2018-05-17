require 'net/http'
require 'uri'

class IndexController < ApplicationController
  def search
    if params[:address].empty?
      redirect_to :action => "index"
    else
      payload = make_payload(params[:address])

      @lat = payload["results"][0]["geometry"]["location"]["lat"]
      @lng = payload["results"][0]["geometry"]["location"]["lng"]

      render 'search'
    end
  end

  def submit_incident
    payload = make_payload(params[:address])

    lat = payload["results"][0]["geometry"]["location"]["lat"]
    lng = payload["results"][0]["geometry"]["location"]["lng"]
    desc = params[:description]

    Incident.create(:latitude => lat, :longitude => lng, :description => desc)

    redirect_to :action => "index"
  end

  def index
    render 'index'
  end

  def fileform
    render 'fileform'
  end

  private
  def make_payload(params)
    address = params.gsub(/\s/,'+')
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{ENV['GEOCODER']}"
    uri = URI.parse(url)
    response = Net::HTTP.get_response uri
    payload = JSON.parse(response.body)
  end
end