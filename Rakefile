require "sinatra/activerecord/rake"
require 'sinatra/asset_pipeline/task'

Sinatra::AssetPipeline::Task.define! App

namespace :db do
  task :load_config do
    require "./app"
  end
end