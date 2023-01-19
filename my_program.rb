puts "==============================="
puts "Do you need an umbrella today?"
puts "==============================="
puts 
puts "Where are you now?"
user_location = gets.chomp
#user_location = "Chicago"
puts "Checking the weather in #{user_location}..."

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
puts "Your coordinates are #{lat}, #{lng}."

darksky_url = "https://api.darksky.net/forecast/71174c5d293588d2f0ba4c0c7448bcfb/#{lat},#{lng}"
darksky_raw_response = URI.open(darksky_url).read
# p darksky_raw_response
darksky_parsed_response = JSON.parse(darksky_raw_response)
data =  darksky_parsed_response.fetch("hourly").fetch("data")


temperature_now = data[0].fetch("temperature").to_i
puts "It is currently #{temperature_now}°F outside."
summary_now = data[0].fetch("summary").capitalize
puts "Next hour: #{summary_now}."

counter = 1
while counter <= 12
  temperature = data[counter].fetch("temperature").to_i
  probability_of_rain = data[counter].fetch("precipProbability")
  percentage = probability_of_rain*100.to_i

  umbrella_bool = false
  if umbrella_bool == false
    if percentage >= 10
      umbrella_bool = true
    end
  end

  puts "In #{counter} hours, the temperature will be #{temperature}°F and there is a #{percentage}% chance of precipitation."
  
  counter += 1
end

if umbrella_bool == true
  puts "You might want to carry an umbrella!"
else
  puts "You probably won't need an umbrella today."
end
