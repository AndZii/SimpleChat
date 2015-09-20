require "dm-core"
require 'dm-migrations'
require 'dm-sqlite-adapter'
require 'sinatra'
require 'json'

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/Chat.db")

class Post
  include DataMapper::Resource

  property :id,     Serial
  property :by,     String
  property :text,   String
  property :created_at, DateTime

end

DataMapper.finalize


DataMapper.auto_migrate!

  DataMapper.auto_upgrade!

  Post.all.each do |post|
    post.destroy if post.by.nil? || post.text.nil?
  end

# 5.times do
# Post.create(:by => "Andrey", :text => "YO!").save
# puts "THis Done Greate!!"
# end

get "/" do

  puts request.path

  @posts = Post.all

  erb :index

  # puts "count = #{@posts.count.to_s}"
  #
  # content_type 'application/json'
  #
  # hashForJSON = {}
  #
  # @posts.each do |post|
  #
  #   hashForJSON["#{post.by.to_s}"] = "#{post.text}"
  #
  # end
  #
  # puts hashForJSON
  #
  # @posts.each do |post|
  #   puts post.by.to_s + " : " + post.text.to_s
  # end
  #
  # hashForJSON.to_json

end

post "/" do

  Post.create(
      :by => params[:by],
      :text => params[:text],
      :created_at => Time.now
  ).save

  @posts = Post.last(10)

  erb :index

  # puts "count = #{@posts.count.to_s}"
  #
  # content_type 'application/json'
  #
  # hashForJSON = {}
  #
  # @posts.each do |post|
  #
  #   hashForJSON["#{post.by.to_s}"] = "#{post.text}"
  #
  # end
  #
  # puts hashForJSON
  #
  # @posts.each do |post|
  #   puts post.by.to_s + " : " + post.text.to_s
  # end
  #
  # hashForJSON.to_json

end