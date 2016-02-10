require 'tilt/erubis'
require 'sinatra'
require 'haml'


require './repository/Posts.rb'
require './repository/Info.rb'
require './repository/Api.rb'

require "dm-core"
require "dm-migrations"
require "digest/sha1"
require "sinatra-authentication"


use Rack::Session::Cookie, :secret => Api.api_data["secret"]

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")
DataMapper.auto_upgrade!

get '/' do
  if logged_in?
    posts = Posts.getAll()
  else
    posts = Posts.getAll().delete_if { |x| x.hidden == true }
  end

  erb :index, :locals => {
    :posts => posts,
    :sidebar => Info.getSidebar()
  }
end

get '/flair/:tag' do
  if logged_in?
    posts = Posts.getByFlair("#{params['tag']}")
  else
    posts = Posts.getByFlair("#{params['tag']}").delete_if { |x| x.hidden == true }
  end

  erb :index, :locals => {
    :posts => posts,
    :sidebar => Info.getSidebar()
  }
end

get '/:id/:title' do
  if logged_in?
    posts = Posts.getSingle("#{params['id']}")
  else
    posts = Posts.getSingle("#{params['id']}").delete_if { |x| x.hidden == true }
  end

  erb :index, :locals => {
    :posts => posts,
    :sidebar => Info.getSidebar()
  }
end
