require_relative 'lib/weather_data'

api = WeatherData.new
api.connect('http://api.openweathermap.org')
api.get_weather('Denver')
x = api.get_forecast('Denver', 7)
puts x
