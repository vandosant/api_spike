require 'faraday'
require 'json'
require 'date'


class TrackerData
  def connect(url)
    @conn = Faraday.new(:url => url) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def get_projects
    response = @conn.get do |req|
      req.url "/services/v5/projects/"
      req.headers['X-TrackerToken'] = ENV['XTRACKERTOKEN']
    end

    project_data = JSON.parse(response.body)

    project_data.map do |project|
      puts '*' * 40
      puts project['name']
      puts "Created on: #{project['created_at']}"
    end
  end

  def get_stories(project_id)
    response = @conn.get do |req|
      req.url "/services/v5/projects/#{project_id}/stories"
      req.headers['X-TrackerToken'] = ENV['XTRACKERTOKEN']
    end

    stories_data = JSON.parse(response.body)

    stories_data.map do |story|
      puts '*' * 40
      puts story['name']
      puts story['description']
      puts story['story_type']
      puts story['current_state']
    end
  end

  def get_story_info(project_id, story_id)
    response = @conn.get do |req|
      req.url "/services/v5/projects/#{project_id}/stories/#{story_id}"
      req.headers['X-TrackerToken'] = ENV['XTRACKERTOKEN']
    end

    story_data = JSON.parse(response.body)

    puts '*' * 40
    puts story_data['name']
    puts story_data['description']
    puts story_data['story_type']
    puts story_data['current_state']
  end
end