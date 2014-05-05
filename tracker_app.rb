require 'dotenv'
require_relative 'lib/tracker_data'

Dotenv.load

api = TrackerData.new
api.connect('https://www.pivotaltracker.com')
api.get_projects
api.get_stories(1072658)
api.get_story_info(1072658, 70631328)


