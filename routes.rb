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
  url_for("/")
  erb :index, :locals => {
    :posts => ensureAuthorized(Posts.getAll()),
    :sidebar => Info.getSidebar()
  }
end

get '/flair/:tag' do
  erb :index, :locals => {
    :posts => ensureAuthorized(Posts.getByFlair("#{params['tag']}")),
    :sidebar => Info.getSidebar()
  }
end

get '/:id/:title' do
  erb :index, :locals => {
    :posts => ensureAuthorized(Posts.getSingle("#{params['id']}")),
    :sidebar => Info.getSidebar()
  }
end

def ensureAuthorized(posts)
  if logged_in? && Api.api_data["allowed"].include?(current_user.email)
    posts
  else
    posts.delete_if { |x| x.hidden == true }
  end

  posts
end

helpers do
  def url_for(fragment)
    puts "#{request.scheme}://#{request.host}:#{request.port}#{request.script_name}#{fragment}"
  end
end
