require 'net/http'
require 'uri'
require 'geokit'

class IncidentsController < ApplicationController
  def search
    if params[:address].empty?
      redirect_to root_path
    else
      payload = make_payload(params[:address])

      @address = params[:address]

      @lat = payload["results"][0]["geometry"]["location"]["lat"]
      @lng = payload["results"][0]["geometry"]["location"]["lng"]

      @incidents = Incident.all
      @incidents = @incidents.select{|incident| distance([@lat, @lng], [incident.latitude, incident.longitude]) <= 5}

      respond_to do |f|
        f.html { redirect_to root_path }
        f.js
      end
    end
  end

  def submit_incident
    if params[:description].empty? || params[:address].empty?

      respond_to do |f|
        f.html { redirect_to root_path }
        f.js
      end
    else
      payload = make_payload(params[:address])

      lat = payload["results"][0]["geometry"]["location"]["lat"]
      lng = payload["results"][0]["geometry"]["location"]["lng"]
      desc = params[:description]
      address = params[:address]

      Incident.create(:latitude => lat, :longitude => lng, :description => desc, :address => address)

      respond_to do |f|
        f.html { redirect_to root_path }
        f.js
      end
    end
  end

  def fileform
    respond_to do |f|
        f.html { redirect_to root_path }
        f.js
      end
  end

  def see_incident
    @incident = Incident.find(params[:id])
    flash.now[:error] = "Your book was not found"
    render 'incident'
  end



  private
  def make_payload(params)
    address = params.gsub(/\s/,'+')
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{ENV['GEOCODER']}"
    uri = URI.parse(url)
    response = Net::HTTP.get_response uri
    payload = JSON.parse(response.body)
  end

  def distance(a,b)
    current_location = Geokit::LatLng.new(a[0],a[1])
    destination = "#{b[0]}, #{b[1]}"
    current_location.distance_to(destination) 
  end
end