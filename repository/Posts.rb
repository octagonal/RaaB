require 'redd'
require 'rdiscount'
require 'htmlentities'
require 'yaml'
require './repository/Api.rb'

class Posts < Api
  def Posts.getAll()
    @@sub.get_hot().each { |post|
      path = post.permalink.split("/").select {|n| n != ""}
      path = path[path.length - 2 .. path.length - 1].join("/")
      post[:permalink] = path
      post[:selftext] = RDiscount.new( HTMLEntities.new.decode(post.selftext) ).to_html
    }.select {|n| !@@NAV_PAGES_FLAIR.find {|word| n.link_flair_text == word}}
  end

  def Posts.getSingle(fullname)
    post = @@w.request_object(:get, "/by_id/t3_" + fullname + ".json", {})[0]
    path = post.permalink.split("/").select {|n| n != ""}
    path = path[path.length - 2 .. path.length - 1].join("/")
    post[:permalink] = path
    post[:selftext] = RDiscount.new( HTMLEntities.new.decode(post.selftext) ).to_html
    [post]
  end

  def Posts.getByFlairSingle(flair)
    @@sub.get_hot().each { |post|
      path = post.permalink.split("/").select {|n| n != ""}
      path = path[path.length - 2 .. path.length - 1].join("/")
      post[:permalink] = path
      post[:selftext] = RDiscount.new( HTMLEntities.new.decode(post.selftext) ).to_html
    }.select {|n| n.link_flair_text == flair}[0,1]
  end
end
