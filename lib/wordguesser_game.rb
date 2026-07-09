class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses, :win, :lose
  # Get a word from remote "random word" service
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError, "Guess can't be nil." if letter == nil
    raise ArgumentError, "Guess must be a letter." if !letter.match(/[a-zA-Z]/)
    letter = letter.downcase
    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    elsif word.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end
  end

  def word_with_guesses()
    display = ""
    word.chars.each do |char|
      if @guesses.include?(char)
        display += char
      else
        display += "-"
      end
    end
    return display
  end

  def check_win_or_lose()
    won = word_with_guesses() == @word
    if won
      :win
    elsif wrong_guesses.length == 7
      :lose
    else
      :play
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://randomword.saasbook.info/RandomWord')
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      response = http.get(uri.path)
      return response.body.scan(/<div>(.+?)<\/div>/).flatten.first
    end
  end
end
