require 'bundler'
Bundler.require

require './model/user.rb'

require './repository/Posts.rb'
require './repository/Info.rb'
require './repository/Api.rb'

# use Rack::Session::Cookie, :secret => Api.api_data["secret"]

Warden::Strategies.add(:password) do
  def valid?
    params['user']['username'] && params['user']['password']
  end

  def authenticate!
    user = User.first(username: params['user']['username'])
    puts user.id
    puts user.username
    if user.nil?
      fail!("The username you entered does not exist.")
    elsif user.authenticate(params['user']['password'])
      success!(user)
    else
      fail!("Could not log in")
    end
  end

end

class RaaB < Sinatra::Base

  def ensureAuthorized(posts)
      if session["warden.user.default.key"] != nil && Api.api_data["allowed"].include?(User.get(session["warden.user.default.key"]).username)
        posts
      else
        posts.delete_if { |x| x.hidden == true }
      end
      posts
  end

  enable :sessions
  set :session_secret, Api.api_data["secret"]

  use Warden::Manager do |config|
    # Tell Warden how to save our User info into a session.
    # Sessions can only take strings, not Ruby code, we'll store
    # the User's `id`
    config.serialize_into_session{|user| user.id }
    # Now tell Warden how to take what we've stored in the session
    # and get a User from that information.
    config.serialize_from_session{|id| User.get(id) }

    config.scope_defaults :default,
      # "strategies" is an array of named methods with which to
      # attempt authentication. We have to define this later.
      strategies: [:password],
      # The action is a route to send the user to when
      # warden.authenticate! returns a false answer. We'll show
      # this route below.
      action: '/'
    # When a user tries to log in and cannot, this specifies the
    # app to send the user to.
    config.failure_app = self
  end

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  get '/' do
    erb :index, :locals => {
      :posts => ensureAuthorized(Posts.getAll()),
      #:posts => Posts.getAll(),
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

  get '/login' do
    erb :login
  end

  post '/login' do
    env['warden'].authenticate!

    if session[:return_to].nil?
      redirect '/'
    else
      redirect session[:return_to]
    end
  end

  get '/update' do
    env['warden'].authenticate!

    erb :update, :locals => {
      :username => User.get(session["warden.user.default.key"]).username
    }
  end

  post '/update' do
    env['warden'].authenticate!

    User.update(:username => User.get(session["warden.user.default.key"]).username, :password => params['user']['password'])

    if session[:return_to].nil?
      redirect '/'
    else
      redirect session[:return_to]
    end
  end

  get '/logout' do
    env['warden'].raw_session.inspect
    env['warden'].logout
    redirect '/'
  end


  helpers do
    def url_for(fragment)
      "#{request.scheme}://#{request.host}:#{request.port}#{request.script_name}#{fragment}"
    end
  end
end
