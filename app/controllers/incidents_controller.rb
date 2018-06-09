require 'net/http'
require 'uri'
require 'geokit'

# This is a style nit, consider adding rubocop to your project to have a consistent style without
# having to manually implement it.

class IncidentsController < ApplicationController
  def search
    if params[:address].empty?
      respond_to do |f|
        f.html { redirect_to root_path }
        f.js { render "search_fail.js.erb" }
      end
    else
      # Do we need @address, @lat, etc to be instance variables, are they used somewhere else?
      # If not, consider extracting lines 20 - 26 into a method that gathers all the incidents
      # and then do
      # @incidents = select_incident_by_query(payload, params)
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
    # Is there a way to DRY up the response of this controller? It seems that in both cases we want to redirect to
    # root_path, I am wondering if there is a way to pass a form to f.js that we could set in the if branches.
    if params[:description].empty? || params[:address].empty?

      respond_to do |f|
        f.html { redirect_to root_path }
        f.js { render "submit_fail.js.erb" }
      end
    else
      # Can we take lines 40 - 56 and put them into their own method? That method's job would be to create a new Incident
      # with the data from make_payload, and could be called "create_new_incident_from_data"
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
    # How do we return a 404 is no incident is found?
    @incident = Incident.find(params[:id])
    
    respond_to do |f|
      f.html { redirect_to root_path }
      f.js
    end
  end



  private
  def make_payload(params)
    # Good job creating this method, as it is used in a couple controllers it cleans up the code nicely.
    address = params.gsub(/\s/,'+')
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{ENV['GEOCODER']}"
    uri = URI.parse(url)
    response = Net::HTTP.get_response uri
    # We don't this need variable assignment, as we don't use it anywhere. Consider changing this line to
    # JSON.parse(response.body)
    # We need to wrap this JSON parser in error handling in case the response is not what we expect (a 400) or
    # it contains weird formatting.
    payload = JSON.parse(response.body)
  end

  def distance(a,b)
    # Is this making a live call to create the new location? If so, we need to add exception
    # handling in case we get back anything other than a success case.
    current_location = Geokit::LatLng.new(a[0],a[1])
    destination = "#{b[0]}, #{b[1]}"
    current_location.distance_to(destination) 
  end
end
