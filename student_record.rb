require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'date'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://#{Dir.pwd}/student-record.db")

class Student
	include DataMapper::Resource
	property :id, Serial
	property :first_name, String
	property :last_name, String
	property :birthday, Date 
	property :address, Text
	property :major, String
	property :minor, String
end

class Users
	include DataMapper::Resource
	property :id, Serial
	property :username, String
	property :password, String
	property :given_name, String
	property :is_logined, String
	property :last_login, Date
end

class Comment
	include DataMapper::Resource
	property :id, Serial
	property :title, Text
	property :Person, String
	property :details, Text
	property :created_at, DateTime
end
DataMapper.finalize

Users.auto_upgrade!
Student.auto_upgrade!
Comment.auto_upgrade!

get '/students' do	#route for students
  if admin?
  @records = Student.all
  erb :students
  else
  redirect to ('/login')
end
end

get '/students/new' do	#route for new student record
if admin?	#check if admin or not and the perform the actions accordingly
  @record = Student.new
  erb :new_student
  else
  redirect to ('/')
end
end

get '/students/:id' do #route for showing student record based on id
if admin?	#check if admin or not and the perform the actions accordingly
  @record = Student.get(params[:id])
  erb :show_student
  else
  redirect to ('/')
end
end

get '/students/:id/edit' do #edit route for student record
 if admin?	#check if admin or not and the perform the actions accordingly
	@record = Student.get(params[:id])
	erb :edit_student
 else
	redirect to ('/')
end
end

post '/students' do	#route show student records
 if admin?	#check if admin or not and the perform the actions accordingly
  record = Student.create(params[:record])
  redirect to("/students/#{record.id}")
  else
	redirect to ('/')
end
end

put '/students/:id' do #update existing record
if admin?	#check if admin or not and the perform the actions accordingly
  record = Student.get(params[:id])
  record.update(params[:record])
  redirect to("/students/#{record.id}")
  else
	redirect to ('/')
end
end

delete '/students/:id' do	#deleting existing student record
 if admin?	#check if admin or not and the perform the actions accordingly
 Student.get(params[:id]).destroy
 redirect to('/students')
 else
	redirect to ('/')
end
end

post '/login' do	#login route to check the username and password set in the sessions
if (params[:username] == settings.username && params[:password] == settings.password)
session[:admin] = true
redirect to ('/students')
else
erb :try_again
end
end

get '/comments' do
	@coms = Comment.all
	erb :comments
end
get '/comments/new' do
	@com = Comment.new
	@com.created_at = DateTime.now
	puts @com.inspect
	
	erb :new_comment
end
get '/comments/:id' do
	@com = Comment.get(params[:id])
	erb :show_comment
end
post '/comments' do
	com = Comment.create(params[:com])
	redirect to ("/comments/#{com.id}")
end
