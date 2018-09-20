require_relative '../../config/environment'
class ApplicationController < Sinatra::Base
  configure do
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  post '/login' do
    if !!@user = User.find_by(username: params["username"])
      #saved as user_id here so need to call like that
      #but need to do find_by(id: session[:user_id]) b/c sql creates id
      session[:user_id] = @user.id
      redirect to '/account'
    else
      erb :error
    end
  end

  get '/account' do
    if session[:user_id] != Helpers.current_user(session).id
      erb :error
    else
      @user = Helpers.current_user(session)
      erb :account
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end


end
