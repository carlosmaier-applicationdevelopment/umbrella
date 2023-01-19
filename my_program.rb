p "Where are you located?"
# user_location = gets.chomp
user_location = "Chicago"

gmaps_key = ENV.fetch("GMAPS_KEY")
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

require("open-uri") #web scraping!
raw_response = URI.open(gmaps_url).read   # p raw_response | still in JSON

require("json")
parsed_response = JSON.parse(raw_response)

results_array = parsed_response.fetch("results")
results_components = results_array[0]
geometry = results_components.fetch("geometry")
location = geometry.fetch("location")
lat = location.fetch("lat")
lng = location.fetch("lng")
p lat
p lng
