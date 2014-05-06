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

    lines = []

    lines << '=' * 23
    lines << "Forecast for #{weather_data['list'].first['name']}"
    lines << '=' * 23
    lines << " #{weather_data['list'].first['weather'].first['description']}."
    lines << " High: #{weather_data['list'].first['main']['temp_max'].to_f}F,"
    lines << " Low: #{weather_data['list'].first['main']['temp_min'].to_f}F,"
    lines << " Wind: #{weather_data['list'].first['wind']['speed']}mph"
    lines << '=' * 26

    lines.join("\n")
  end

  def get_forecast(city, length_in_days)
    response = @conn.get("/data/2.5/forecast/daily", :q => city, :cnt => length_in_days, :units => 'imperial')
    forecast_data = JSON.parse(response.body)

    lines = []

    lines << '=' * 26
    lines << "#{forecast_data['cnt']}-Day Forecast for #{forecast_data['city']['name']}"
    lines << '=' * 26
    forecast_data['list'].each_with_index do |day_data, index|
      lines << (Date.today + index)
      lines << " #{day_data['weather'].first['description'].capitalize}."
      lines << " High: #{day_data['temp']['max'].to_f}F,"
      lines << " Low: #{day_data['temp']['min'].to_f}F,"
      lines << " Wind: #{day_data['speed']}mph"
    end
    lines << '=' * 26

    lines.join("\n")
  end
end