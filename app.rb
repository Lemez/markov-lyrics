require 'sinatra'
require "opal"
require 'react'
require 'sinatra/partial'
require 'slim'
require "sinatra/activerecord"
require 'sinatra-initializers'
require 'pry'
require 'sinatra/base'
require 'sinatra/asset_pipeline'
require 'sinatra/assetpack'

require_relative "./a"

set :database, {adapter: "sqlite3", database: "markov.sqlite3"}
# or set :database_file, "path/to/database.yml"

Slim::Engine.set_options shortcut: {'&' => {tag: 'input', attr: 'type'}, '#' => {attr: 'id'}, '.' => {attr: 'class'}}

class HelloWorldApp < Sinatra::Base

	register Sinatra::ActiveRecordExtension
	register Sinatra::Initializers
   	register Sinatra::Partial
   	register Sinatra::AssetPack

  	set :public_folder, 'public'
	set :partial_template_engine, :slim
	enable :partial_underscores
	enable :sessions

	set :root, File.dirname(__FILE__) # You must set app root
	set :static, true #PUT ALL STATIC FILES IN PUBLIC!

	set :assets_precompile, %w(app.js app.css *.png *.jpg *.svg *.ogg *.wav *.swf)
	register Sinatra::AssetPipeline 

	assets {

		    serve '/js',     from: 'app/js'        # Default
		    serve '/css',     from: 'app/css'        # Default
		    serve '/audio', from: 'app/audio' 

		    js :application, [
			    '/js/jquery-1.9.1.min.js',
			    '/js/*.js'
  			]
  			css :application, [
			    '/css/*.css'
		   	]  
  	}

  	@@reloading = true
  	
  	
	get '/' do

	    	pattern,speed,pitch = params[:patterns], params[:speed], params[:pitch]
	    
	     	unless TEST
	     		get_markov_data(pattern,speed,pitch) if @@reloading

	     		@song = save_song_data_to_db

	     	end

	     	TEST ? @data = TESTVERSES : @data = @@verses
	     	TEST ? @chorus = TESTCHORUS : @chorus = @@chorus

	     	validate_speed(speed)

	      	slim :index,
		       :locals => { :pattern => pattern, :speed => speed, :pitch => pitch}

	end

	get "/array", :provides => :json do
    	content_type :json
    	@chorus.to_json
 	 end

	put '/' do

	    	  pattern = params[:patterns]
		      speed = params[:speed]
		      pitch = params[:pitch]
		  	 
		  	  @@reloading = false

		      slim :index,
		       :locals => { :pattern => pattern, :speed => speed, :pitch => pitch}

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


