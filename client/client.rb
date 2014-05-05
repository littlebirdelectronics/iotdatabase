#!/usr/bin/env ruby

require 'rubygems'
require 'w1temp'
require 'httparty'

sensor = Temperature.new

require 'artoo'

api :host => '10.0.1.24', :port => '4321'

connection :raspi, :adaptor => :raspi
device :led, :driver => :led, :pin => 15

work do
  every 1.second do
    led.toggle
    puts led.inspect
    puts "#{sensor.reading} for #{sensor.name}"
    @result = HTTParty.post("http://littlebirdiot.herokuapp.com/update",
    :body => { :sensor => sensor.name,
               :reading => sensor.reading}
     )
  end
end