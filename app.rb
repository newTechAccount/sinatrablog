# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

enable :sessions


class Post < ActiveRecord::Base
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true
end

helpers do
  def title
    if @title
      "#{@title}"
    else
      "Welcome."
    end
  end

  def delete_post_button(id)
    erb :_delete_post_button, locals: { id: id}
  end
end

get "/" do
  @posts = Post.order("created_at DESC")
  @title = "Welcome."
  erb :"posts/index"
end

get "/posts/create" do
  @title = "Create post"
  @post = Post.new
  erb :"posts/create"
end

post "/posts" do
  @post = Post.new(params[:post])
  if @post.save
    redirect "posts/#{@post.id}", :notice => 'Congrats! Love the new post. (This message will disapear in 4 seconds.)'
  else
    redirect "posts/create", :error => 'Something went wrong. Try again. (This message will disapear in 4 seconds.)'
  end
end

get "/posts/:id" do
  @post = Post.find(params[:id])
  @title = @post.title
  erb :"posts/view"
end

# Deletes the post with this ID and redirects to homepage.
delete "/posts/:id" do
  @post = Post.find(params[:id]).destroy
  redirect "/"
end