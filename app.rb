require 'sinatra'
require "opal"
require 'react'
require 'sinatra/partial'
require 'slim'
require "sinatra/activerecord"
require 'sinatra-initializers'

require_relative "./a"

set :database, {adapter: "sqlite3", database: "markov.sqlite3"}
# or set :database_file, "path/to/database.yml"

class HelloWorldApp < Sinatra::Base

	register Sinatra::ActiveRecordExtension
	register Sinatra::Initializers
   	register Sinatra::Partial
	set :partial_template_engine, :slim
	enable :partial_underscores
	enable :sessions

	    get '/' do
	      pattern = params[:p]
	      get_markov_data(pattern)
	  	  @data = @@verses
	  	  @chorus = @@chorus
	  	  @patterns = PATTERNS
	      slim :index 
	    end

	    post '/' do
	      pattern = params[:patterns]
	      p "===========#{pattern}============="
	      redirect "/?p=#{pattern}"
	    end


		# configure do
		#   enable :sessions
		# end

		# helpers do
		#   def username
		#     session[:identity] ? session[:identity] : 'Hello stranger'
		#   end
		# end

		# before '/secure/*' do
		#   unless session[:identity]
		#     session[:previous_url] = request.path
		#     @error = 'Sorry, you need to be logged in to visit ' + request.path
		#     halt erb(:login_form)
		#   end
		# end

		# get '/' do
		#   erb 'Can you handle a <a href="/secure/place">secret</a>?'
		# end

		# get '/login/form' do
		#   erb :login_form
		# end

		# post '/login/attempt' do
		#   session[:identity] = params['username']
		#   where_user_came_from = session[:previous_url] || '/'
		#   redirect to where_user_came_from
		# end

		# get '/logout' do
		#   session.delete(:identity)
		#   erb "<div class='alert alert-message'>Logged out</div>"
		# end

		# get '/secure/place' do
		#   erb 'This is a secret place that only <%=session[:identity]%> has access to!'
		# end
end


