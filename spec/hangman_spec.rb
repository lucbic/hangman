require_relative '../hangman'

describe Hangman do
  subject { Hangman.new(word, guess, try, misses, cipher) }

  context "when shift is 1" do
    let(:shift) { 1 }

    it "shifts 'a' to 'b'" do
      expect(subject.to_cipher('a')).to eql 'b'
    end
  end
end
