class HangpersonGame

  attr_accessor :word, :guesses, :wrong_guesses, :hidden_word, :temp_word, :status

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @hidden_word = '-' * word.size
    @temp_word = word
    @status = ''
  end

  def guess(letter)
    letter.downcase! if /([A-Z])/.match(letter)
    if /[^A-Za-z0-9]/.match(letter) || letter.nil? || letter.empty?
      raise ArgumentError.new("You must inform a letter")
    elsif @guesses.include?(letter)
      return false
    else
      if @word.include?(letter)
        if @guesses.include?(letter)      # does not change guess list if the letter is repeated
          return false               # and return false for @valid
        else
          @guesses += letter            # add the letter guessed to the guess list
          word_with_guesses   # change the character '-' inside the variable hidden_word for the equivalent letter
        end
      else
        if @wrong_guesses.include?(letter)
          return false
        else
          @wrong_guesses += letter
        end
      end
    end
  end

  def word_with_guesses
    check_win_or_lose
    @guesses.each_char do |i|
      while @temp_word.include?(i) && @hidden_word != @word
        char_index = @temp_word.index(i)
        @hidden_word[char_index] = i
        @temp_word[char_index] = '-'
      end
    end
      return @hidden_word
  end

  def check_win_or_lose
    if @guesses.size == @word.size
      @status = :win
    elsif @wrong_guesses.size >= 6
      @status = :lose
    else
      @status = :play
    end
    return @status
  end


  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end
end
