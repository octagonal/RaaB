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
    puts current_user.email
  end

  erb :index, :locals => {
    :posts => Posts.getAll(),
    :sidebar => Info.getSidebar()
  }
end

get '/flair/:tag' do
  erb :index, :locals => {
    :posts => Posts.getByFlair("#{params['tag']}"),
    :sidebar => Info.getSidebar()
  }
end

get '/:id/:title' do
  erb :index, :locals => {
    :posts => Posts.getSingle("#{params['id']}"),
    :sidebar => Info.getSidebar()
  }
end
