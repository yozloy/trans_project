require 'sinatra'
require 'riak'
get '/' do 
	erb :list,:layout => :layout
end
