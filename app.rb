# run with  
# rackup
# and access at http://localhost:9292/ or http://rebeats-markov.dev:9292/

require 'sinatra'
require "opal"
require 'react'
require_relative "./a"
require 'sinatra/partial'

class HelloWorldApp < Sinatra::Base
	register Sinatra::Partial
	set :partial_template_engine, :erb
	enable :partial_underscores
	
	    get '/' do

	      get_markov_data
	  	  @data = @@verses
	      erb :index

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


