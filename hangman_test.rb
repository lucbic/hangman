class Hangman

  WORDS = ['umbrella', 'metropolis', 'project', 'insect', 'miracle', 'sausage', 'manager', 'politics', 'helicopter', 'adventure', 'original', 'response', 'depression', 'broadcast', 'contact', 'middle', 'missile', 'pepper', 'discovery']

  ALPHA = "abcdefghijklmnopqrstuvwxyz"

  attr_reader :try
  attr_reader :message
  attr_reader :message_style
  attr_reader :game_over

  def get_misses()
    misses_str = "Misses: "
    unless @misses.empty?
      @misses.each do |i| misses_str << "[ #{i} ] " end
    end
    misses_str
  end

  def get_temp_word()
    word_out = ""
    @temp_word.each_char do |c|
      word_out << c + " "
    end
    word_out.chop
  end

  def initialize()
    @word = generate_word
    @try = 0
    @temp_word = generate_temp_word(@word)
    @misses = []
    @message = "Type in a character"
    @message_style = "normal"
    @game_over = false
    @success = false
    @typed = []
  end

  def iteration(guess)
    guess = guess.downcase
    word_build = ""

    @word.each_char.with_index do |i, index|
      if @temp_word[index] != '_'
        word_build << @temp_word[index]
        @success = true
      elsif guess == i
        word_build << i
        @success = true
      else
        word_build << '_'
        @success = false
      end
    end

    if @success == false && !(@misses.include? guess) && format_ok?(guess)
      @misses.push(guess)
    end

    if @try == 5 && @success == false && format_ok?(guess)
      @game_over = true
    end

    if word_build == @word
      @success = true
      @game_over = true
    end

    @temp_word = word_build

    if !format_ok?(guess)
      @message = "Type in a single valid character"
      @message_style = "fail"
    elsif @typed.include? guess
      @message = "This character has already been typed in"
      @message_style = "fail"
    else
      @typed << guess
      if @success && @game_over
        @message = "You won<br>Congratulations!"
        @message_style = "won"
      elsif !@success && @game_over
        @message = "You lose<br>GAME OVER"
        @message_style = "fail"
        @try += 1
      elsif !@success && !@game_over
        @message = "Type in a character"
        @message_style = "normal"
        @try += 1
      elsif @success && !@game_over
        @message = "Type in a character"
        @message_style = "normal"
      end
    end
  end

  def generate_word
    WORDS.sample
  end

  def generate_temp_word(word)
    temp_word = ""
    word.each_char do |j|
      temp_word << '_'
    end
    temp_word
  end

  def format_ok?(guess)
    guess = guess.downcase
    if guess.length != 1 then false
    elsif !ALPHA.include?(guess) then false
    else true end
  end

end
