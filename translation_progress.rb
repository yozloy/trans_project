require 'sinatra'
require 'riak'
get '/' do 

	@c = Riak::Client.new
	@b = @c.bucket('trans_projects')
	@keys = @b.keys
	@a = @keys.map do |k|
		@b.get(k)
	end.sort do |y,x| 
		x.data["number"] <=> y.data["number"]
	end
erb :list,:layout => :layout
end

get '/new' do
<<-HERE
<form aciton="egwgwgw" method="post">
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

post '/update/:key' do 
	@c = Riak::Client.new
	@b = @c.bucket('trans_projects')
	@o = @b.get(params[:key])
	@o.data[:status] = params[:name][:status]
	if @o.store
		redirect to('/') 
	else
		redirect to('/error')
	end
end

post '/count/:key' do
#	f = File.open('tmp','w+')
#	f << params[:name][:transcript]
#	f.close
#	a = `wc tmp`.split(' ')
#	File.delete('tmp')
	a = params[:name][:transcript].split(' ')
	@c = Riak::Client.new
	@b = @c.bucket('trans_projects')
	@o = @b.get(params[:key])
	@o.data[:words] = a.size
	if @o.store
		redirect to('/')
	else
		redirect to('/error')
	end
end

delete '/delete/:key' do
	c = Riak::Client.new
	r = c['trans_projects'][params[:key]]
	if r.delete
		redirect to('/')
	end
end
