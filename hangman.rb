WORDS = ['umbrella', 'metropolis', 'project', 'insect', 'miracle', 'sausage', 'manager', 'politics', 'helicopter', 'adventure', 'original', 'response', 'depression', 'broadcast', 'contact', 'middle', 'missile', 'pepper', 'discovery']

ALPHA = "abcdefghijklmnopqrstuvwxyz"

def hangman(word, guess, try, misses, cipher)
  temp_word = ""
  success = false
  game_over = false
  # binding.pry

  word.each_char.with_index do |i, index|
    guess.downcase
    if guess == i
      temp_word << i
      success = true
    elsif cipher[index] != '_'
      temp_word << cipher[index]
    else
      temp_word << '_'
    end
  end

  if success == false && !(misses.include? guess)
    misses.push(guess.downcase)
  end

  if (try == 5 && success == false) then game_over = true end

  if temp_word == word
    success = true
    game_over = true
  end

  return temp_word, success, misses, game_over
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

def stringify_misses(misses)
  misses_str = "Misses: "
  unless misses.empty?
    misses.each do |i| misses_str << "[ #{i} ] " end
  end
  misses_str
end

def test_guess(guess)
  guess = guess.downcase
  if guess.length != 1 then false
  elsif !ALPHA.include?(guess) then false
  else true end
end

def spaces(word)
  word_out = ""
  word.each_char do |c|
    word_out << c + " "
  end
  word_out.chop
end
