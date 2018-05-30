require 'sinatra'
require 'rubygems'
require 'sass'
require './student_record'


get('/styles.css'){ scss :styles }

configure do
enable :sessions	#sessions to track
set :username, 'mounika'	#username for login
set :password, 'mounikam'	#password for login
end

helpers do	#helper method to check for admin all the time
  def admin?
    session[:admin]
  end
end

get '/' do	#Login Module. Eliminates '/login' url
  erb :home
end

get '/login' do
  erb :login
end

get '/home' do	#Route for Homepage
  erb :home
end

get '/students' do
  erb :students
end

get '/about' do	#Route for About page
  @title = "About"
  erb :about
end

get '/contact' do	#Route for Contact page
  @title = "Contact"
  erb :contact
end

get '/comment' do
	@title = "comment page"
	erb :comments
end

get '/video' do
	@title = "video"
	erb :video

end

get '/logout' do	#for logging out users
session.clear
session[:admin] = false
redirect to ('/')
end
DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://#{Dir.pwd}/student-record.db")
