require './weather_data'

api = WeatherData.new
api.connect('http://api.openweathermap.org')
api.get_weather('Denver')
api.get_forecast('Denver', 7)
