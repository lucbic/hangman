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
  unless session["try"]
    session["try"] = 0
    session["word"] = generate_word
    session["temp_word"] = generate_temp_word(session["word"])
    session["misses"] = []
    session["message"] = "Type in a character"
    session["m_style"] = "normal"
    session["game_over"] = false
    session["typed"] = []
  end

  @try = session["try"]
  @temp_word = spaces(session["temp_word"])
  @misses = stringify_misses(session["misses"])
  @message = session["message"]
  @m_style = session["m_style"]
  @game_over = session["game_over"]
  erb :index
end

post '/guess' do
  # binding.pry if session["try"] == 5
  @guess = params[:guess]
  if !test_guess(@guess)
    session["message"] = "Type in a single valid character"
    session["m_style"] = "fail"
  elsif session["typed"].include? @guess
    session["message"] = "This character has already been typed in"
    session["m_style"] = "fail"
  else
    # binding.pry if session["message"] == "Type in a single valid character"
    session["temp_word"], @success, session["misses"], @game_over = hangman(session["word"], @guess, session["try"], session["misses"], session["temp_word"])
    session["typed"] << @guess
    session["game_over"] = @game_over
    if @success && @game_over
      session["message"] = "You won. Congratulations!"
      session["m_style"] = "won"
    elsif !@success && @game_over
      session["message"] = "You lose..."
      session["m_style"] = "fail"
      session["try"] += 1
    elsif !@success && !@game_over
      session["message"] = "Type in a character"
      session["m_style"] = "normal"
      session["try"] += 1
    else
      session["message"] = "Type in a character"
      session["m_style"] = "normal"
    end
  end
  redirect "/"
end

post '/reset' do
  session.clear
  redirect "/"
end
