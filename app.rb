require 'sinatra'
require_relative 'hangman'

if development?
  require 'dotenv/load'
  require "better_errors"
  require 'pry'
  require 'sinatra/reloader'
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path("..", __FILE__)
end

configure do
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET']
end

get '/' do
  unless session["hangman"]
    session["hangman"] = Hangman.new
  end
  @hangman = session["hangman"]
  erb :index
end

post '/guess' do
  session["hangman"].iterate(params[:guess])
  redirect "/"
end

post '/reset' do
  session.clear
  redirect "/"
end
