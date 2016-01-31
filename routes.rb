require 'tilt/erubis'
require 'sinatra'
require 'redd'
require 'json'
require 'rdiscount'
require 'htmlentities'
require 'yaml'

NAV_PAGES_FLAIR = ["aboutme", "resume"]

api_data = YAML::load_stream(File.open("./api_data.yaml")).first["api"];
w = Redd.it(:userless, api_data["client_id"], api_data["secret"], user_agent: api_data["user_agent"])
sub = w.subreddit_from_name("RaaB")

get '/' do
  erb :index, :locals => {
    :posts =>
      sub.get_hot().each { |post|
        path = post.permalink.split("/").select {|n| n != ""}
        path = path[path.length - 2 .. path.length - 1].join("/")
        post[:permalink] = path
        post[:selftext] = markdown( HTMLEntities.new.decode(post.selftext) )
      }.select {|n| !NAV_PAGES_FLAIR.find {|word| n.link_flair_text == word}},
    :sidebar =>
      markdown( HTMLEntities.new.decode(sub.description))
  }
end


get '/aboutme' do
  erb :index, :locals => {
    :posts =>
      sub.get_hot().each { |post|
        path = post.permalink.split("/").select {|n| n != ""}
        path = path[path.length - 2 .. path.length - 1].join("/")
        post[:permalink] = path
        post[:selftext] = markdown( HTMLEntities.new.decode(post.selftext) )
      }.select {|n| n.link_flair_text == "aboutme"},
    :sidebar =>
      markdown( HTMLEntities.new.decode(sub.description))
  }
end
