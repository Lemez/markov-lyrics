require 'ruby_rhymes'
require 'rhymes'

RHYMES = Rhymes.new 

def get_last_word_rhyme(line)
	words = line.gsub(/[^A-Za-z ]/i, '')
	word = words.split(" ")[-1]
	begin
		return RHYMES.rhyme(word).sort_by(&:length).first
	rescue Rhymes::UnknownWord => e
		return nil
	end
end

def get_rhyme(line)
	line.to_phrase.flat_rhymes
end

