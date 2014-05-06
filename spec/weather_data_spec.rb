require 'spec_helper'
require_relative '../lib/weather_data'


describe WeatherData do
  it 'gets weather data for a chosen city' do
    VCR.use_cassette('weather_denver') do
      weather = WeatherData.new
      weather.connect('http://api.openweathermap.org')

      results = weather.get_weather('Denver')

      expected = <<-INPUT
=======================
Forecast for Denver
=======================
 scattered clouds.
 High: 72.37F,
 Low: 72.37F,
 Wind: 5.79mph
==========================
      INPUT

      expect(results).to eq expected.chomp
    end
  end

  it 'gets forecast data for chosen days and city' do
    VCR.use_cassette('forecast_denver') do
      weather = WeatherData.new
      weather.connect('http://api.openweathermap.org')

      results = weather.get_forecast('Denver', 7)

      expected = <<-INPUT
==========================
7-Day Forecast for Denver
==========================
2014-05-06
 Scattered clouds.
 High: 71.38F,
 Low: 59.5F,
 Wind: 4.69mph
2014-05-07
 Light rain.
 High: 60.03F,
 Low: 42.12F,
 Wind: 12.55mph
2014-05-08
 Snow.
 High: 44.65F,
 Low: 33.06F,
 Wind: 16.57mph
2014-05-09
 Sky is clear.
 High: 59.5F,
 Low: 29.66F,
 Wind: 4.02mph
2014-05-10
 Sky is clear.
 High: 62.08F,
 Low: 36.86F,
 Wind: 15.68mph
2014-05-11
 Moderate rain.
 High: 57.25F,
 Low: 37.6F,
 Wind: 11.56mph
2014-05-12
 Light rain.
 High: 58.42F,
 Low: 33.13F,
 Wind: 4.45mph
==========================
      INPUT

      expect(results).to eq expected.chomp
    end
  end
end