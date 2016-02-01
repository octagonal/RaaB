require 'tilt/erubis'
require 'sinatra'

require './repository/Posts.rb'
require './repository/Info.rb'

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
    :posts => Posts.getByFlair("#{params['flair']}"),
    :sidebar => Info.getSidebar()
  }
end
