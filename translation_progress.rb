require 'sinatra'
require 'riak'
get '/' do 
	@c = Riak::Client.new
	@b = @c.bucket('trans_projects')
	@keys = @b.keys
erb :list,:layout => :layout
end

get '/new' do
<<-HERE
<form aciton="/egegegew" method="post">
		<input type="text" name="name[number]" />
		<input type="text" name="name[url]" />
		<input type="submit" name="give it to me" />
	</form>
	HERE
end

post '/new' do
@c = Riak::Client.new
@b = @c.bucket('trans_projects')
@new_one = Riak::RObject.new(@b)
@new_one.content_type = "application/json"
@new_one.data = {number: params[:name][:number].to_i, url: params[:name][:url]}
if @new_one.store
	redirect to('/') 
else
	redirect to('/error')
end
end

get '/error' do
	"Something wrong"
end

