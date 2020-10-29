require 'sinatra/base'
require 'pg'
require_relative './lib/space'
require_relative './database_connection.rb'
require_relative './lib/connection'
require_relative './lib/user.rb'

class BnbManager < Sinatra::Base
  enable :sessions

  run! if app_file == $0

  get '/' do
    erb :index
  end

  get '/spaces' do
    @result = Space.all
    @user = User.find(id: session['id'])
    # @display_name = session['display_name']
    # @display_name = @user.display_name
    erb :'/spaces/index'
  end

  get '/spaces/new' do
    erb :'/spaces/new'
  end

  post '/spaces' do
    Space.create(name: params[:space_name], description: params[:description])


    redirect to '/spaces'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    session['display_name'] = params['display_name']
    @user = User.create(email: params['email'], password: params['password'], display_name: params['display_name'])
    session['id'] = @user.id
    redirect '/spaces'
  end


end
