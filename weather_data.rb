require 'faraday'
require 'json'
require 'date'

class WeatherData
  def connect(url)
    @conn = Faraday.new(:url => url) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def get_weather(city)
    response = @conn.get("/data/2.5/find", :q => city, :units => 'imperial')
    weather_data = JSON.parse(response.body)

    puts '=' * 23
    puts "Forecast for #{weather_data['list'].first['name']}"
    puts '=' * 23
    puts " #{weather_data['list'].first['weather'].first['description']}."
    puts " High: #{weather_data['list'].first['main']['temp_max'].to_i}F,"
    puts " Low: #{weather_data['list'].first['main']['temp_min'].to_i}F,"
    puts " Wind: #{weather_data['list'].first['wind']['speed']}mph"
    puts '=' * 26
  end

  def get_forecast(city, length_in_days)
    response = @conn.get("/data/2.5/forecast/daily", :q => city, :cnt => length_in_days, :units => 'imperial')
    forecast_data = JSON.parse(response.body)

    puts '=' * 26
    puts "#{forecast_data['cnt']}-Day Forecast for #{forecast_data['city']['name']}"
    puts '=' * 26
    forecast_data['list'].each_with_index do |day_data, index|
      puts (Date.today + index)
      puts " #{day_data['weather'].first['description'].capitalize}."
      puts " High: #{day_data['temp']['max'].to_i}F,"
      puts " Low: #{day_data['temp']['min'].to_i}F,"
      puts " Wind: #{day_data['speed']}mph"
    end
    puts '=' * 26
  end
end