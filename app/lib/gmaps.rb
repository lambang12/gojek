class Gmaps
  GMAPS = GoogleMapsService::Client.new(key: ENV["GOOGLE_API_KEY"])

  def self.to_coordinates(address)
    geocodes = GMAPS.geocode(address)
    coordinates = {}
    coordinates = {
      lat: geocodes[0][:geometry][:location][:lat],
      lng: geocodes[0][:geometry][:location][:lng]
    } unless geocodes.empty?
  end

  def self.distance_in_km(origin, destination)
    distance_matrix = GMAPS.distance_matrix(origin, destination)
    distance = -1
    unless distance_matrix[:rows][0][:elements][0][:status] == "NOT_FOUND"
      distance = distance_matrix[:rows][0][:elements][0][:distance][:value]
      distance = (distance / 1000).round(2)
    end
    distance
  end
end