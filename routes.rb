require 'tilt/erubis'
require 'sinatra'
require 'redd'
require 'json'
require 'rdiscount'
require 'htmlentities'
require 'yaml'

require './repository/Posts.rb'
require './repository/Info.rb'
require 'nokogiri'

get '/' do

  erb :index, :locals => {
    :posts => Posts.getAll(),
    :sidebar => Info.getSidebar()
  }
end


get '/:id/:title' do
  erb :index, :locals => {
    :posts => Posts.getSingle("#{params['id']}"),
    :sidebar => Info.getSidebar()
  }
end


get '/:flair' do
  erb :index, :locals => {
    :posts => Posts.getByFlairSingle("#{params['flair']}"),
    :sidebar => Info.getSidebar()
  }
end
