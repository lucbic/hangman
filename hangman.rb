class Hangman

  WORDS = ['UMBRELLA', 'METROPOLIS', 'PROJECT', 'INSECT', 'MIRACLE', 'SAUSAGE', 'MANAGER', 'POLITICS', 'HELICOPTER', 'ADVENTURE', 'ORIGINAL', 'RESPONSE', 'DEPRESSION', 'BROADCAST', 'CONTACT', 'MIDDLE', 'MISSILE', 'PEPPER', 'DISCOVERY']

  ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

  def initialize
    @word = WORDS.sample
    @temp_word = '_' * @word.size
    @typed = []
    @misses = []
    @game_over = false
    @success = false
    @error = false
  end

  def iterate(guess)
    guess = guess.upcase
    if !format_ok?(guess)
      @error = true
      @success = false
    elsif @typed.include? guess
      @error = true
      @success = true
    elsif @word.include? guess
      include_temp_word(guess)
      @typed << guess
      @game_over = true if @temp_word == @word
      @success = true
      @error = false
    else
      @misses << guess
      @typed << guess
      @game_over = true if @misses.count == 6
      @success = false
      @error = false
    end
  end

  def misses
    misses_str = "Misses: "
    unless @misses.empty?
      @misses.each do |i| misses_str << "[ #{i} ] " end
    end
    misses_str.chop
  end

  def temp_word
    word_out = ""
    @temp_word.each_char do |c|
      word_out << c + " "
    end
    word_out.chop
  end

  def message_style
    if @error || @game_over && !@success
      "fail"
    elsif @game_over && @success
      "won"
    else
      "normal"
    end
  end

  def message
    if @error && !@success
      "Type in a single valid character"
    elsif @error && @success
      "This character has already been typed in"
    elsif !@error && @game_over && @success
      "You won<br>Congratulations!"
    elsif !@error && @game_over && !@success
      "You lose<br>GAME OVER"
    else
      "Type in a character"
    end
  end

  def try
    @misses.count
  end

  def game_over
    @game_over
  end

  private

  def format_ok?(guess)
    guess = guess.upcase
    if guess.length != 1 then false
    elsif !ALPHA.include?(guess) then false
    else true end
  end

  def include_temp_word(guess)
    word_build = ""
    @word.each_char.with_index do |i, index|
      if @temp_word[index] != '_'
        word_build << @temp_word[index]
      elsif guess == i
        word_build << i
      else
        word_build << '_'
      end
    end
    @temp_word = word_build
  end

end
