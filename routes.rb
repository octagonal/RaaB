require 'tilt/erubis'
require 'sinatra'
require 'redd'
require 'json'
require 'rdiscount'
require 'htmlentities'

NAV_PAGES_FLAIR = ["aboutme", "resume"]

w = Redd.it(:userless, "yqjP_uLm53Pa-g", "k5ZHJce1Eg9y04yGyLC719fXcBE0", user_agent: "Web:yqjP_uLm53Pa-g:v0.0.1 (by /u/pegasus_527)")
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
