require 'redd'
require 'rdiscount'
require 'htmlentities'
require 'yaml'
require './repository/Api.rb'
require './utils/authentication.rb'

class Posts < Api
  def Posts.getAll()
    @@sub.get_hot().each { |post|
      Posts.fmt(post)
    }.select {|n| !@@NAV_PAGES_FLAIR.find {|word| n.link_flair_text == word}}
  end

  def Posts.getSingle(fullname)
    puts fullname
    post = @@w.request_object(:get, "/by_id/t3_" + fullname + ".json", {})[0]
    [Posts.fmt(post)]
  end

  def Posts.getByFlair(flair)
    @@sub.get_hot().each { |post|
      Posts.fmt(post)
    }.select {|n| n.link_flair_text == flair}
  end

  def Posts.fmt(post)
    path = post[:permalink].split("/").select {|n| n != ""}
    path = path[path.length - 2 .. path.length - 1].join("/")
    post[:permalink] = path
    if(post[:title].start_with?("[ENC] "))
      post[:hidden] = true
      post[:title].sub!("[ENC] ", "")
      post[:selftext] = Encryption.decrypt(post[:selftext].split().join(" ").unpack('m').first())
      post[:title] = Encryption.decrypt(post[:title].split().join(" ").unpack('m').first())
    else
      post[:hidden] = false
    end
    post[:selftext] = RDiscount.new( HTMLEntities.new.decode(post[:selftext]) ).to_html

    post
  end
end
