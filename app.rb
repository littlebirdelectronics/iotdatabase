#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'mongo'
require 'mongo_mapper'
require 'chartkick'

MongoMapper.connection = Mongo::Connection.new("oceanic.mongohq.com", 10000)
MongoMapper.database = 'datapoints'
MongoMapper.database.authenticate('littlebird', 'MchPKyA7')


class DataPoint
  include MongoMapper::Document
  key :sensor, String
  key :reading, Float
  timestamps!
end


get '/' do
  "Welcome"
end


post '/update' do


  datapoint = DataPoint.new({
    :sensor => params["sensor"],
    :reading => params["reading"],
  })

  datapoint.save

  "ok got it"
end

get '/sensor/:sensor' do

  @data = {} # Create a hash for sticking our datapoints into.

  # Fetch the data points from the database
  datapoints = DataPoint.all(:sensor => params["sensor"])

  # Loop through the returned data points and stick them in the hash
  datapoints.each do |point|
  	@data["#{point.created_at}"] = point.reading
  end

  # Render the readings view. It's in ./views/readings.erb
  erb :readings
end
