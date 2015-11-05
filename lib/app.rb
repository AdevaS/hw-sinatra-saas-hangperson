require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  before do
    @game = session[:game] || HangpersonGame.new('')
  end

  after do
    session[:game] = @game
  end

  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    # Don't change next line: it's necessary for autograder to work properly.
    word = params[:word] || HangpersonGame.get_random_word # don't change this line!
    # Don't change the above line: it's necessary for autograder to work properly.

    # Your additional code goes here:
    @game = HangpersonGame.new(word)

    redirect '/show'
  end

  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    # get the guessed letter from params[:guess] (note: if user left it blank,
    #   params[:guess] will be nil)
    letter = params[:guess].to_s[0]

    # Try guessing the letter.  If it has already been guessed,
    #   display "You have already used that letter."
    if @guesses.include?(letter)
      flash[:message] = "You have already used that letter."
      #redirect '/show'
    elsif letter.is_a? NilClass
      flash[:message] = "Invalid guess."
      redirect '/show'
    else
      @game.guess(letter)
    end

    # Either way, the user should then be shown the main game screen ('show' action).
    redirect '/show'
  end

  get '/show' do

    @game.check_win_or_lose
    if @status == :win
      redirect '/win'
    elsif @status == :lose
      redirect '/lose'
    else
      redirect '/show'
    end
    # To show the game status, use the check_win_or_lose function.
    # If player wins (word completed), do the 'win' action instead.
    # If player loses (all guesses used), do the 'lose' action instead.
    # Otherwise, show the contents of the 'show.erb' (main game view) template.
    erb :show
  end

  get '/win' do
    # Player wins. WARNING: prevent cheating by making sure the game has really been won!
    #  If player tries to cheat, they should be shown the main game view instead.  (And
    #  you can optionally supply a "No cheating!" message.)
    # If they really did win, show the 'win' view template.
    if @game.check_win_or_lose == :win
      erb :win
    else
      redirect '/show'
    end
  end

  get '/lose' do
    # Player loses. WARNING: make sure the game has really been lost!
    # If they really did lose, show the 'win' view template.
    # Otherwise, show the main game view instead.

    if @game.check_win_or_lose == :lose
      erb :lose
    else
      redirect '/show'
    end
  end

end
