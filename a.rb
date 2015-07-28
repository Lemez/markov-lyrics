
require 'awesome_print'

# require 'words'
# require 'wordnet'
# WORDS = WordNet::Sense.new

require_relative './array'
require_relative './string'
require_relative './verse'
require_relative './models/song'

require_relative './markov'
require_relative './song'
require_relative './nlp'
require_relative './syllables'
require_relative './rhyme'
require_relative './meaning'
require_relative './speak'


def get_markov_data(pattern,speed,pitch)

	setup_song(pattern,speed,pitch)
	
	print_markov(NUMBER)
	# keep_going_if_not_enough

	sort_lines_into_rhymes
	detect_last_pos
	define_verse_pattern
	make_chorus


	# get_ipa line
end

def keep_going_if_not_enough
	while @@data.length < 50
		p @@data.length
	  	 print_markov(NUMBER)
	end
end


def sort_lines_into_rhymes

	@d = @@data.dup
	@unique = @d.uniq {|x|x[-1]}
	@d -= @unique

	d_rhymes = @d.map{|c| c[-1]}

	@unique.each do |r|
	 if d_rhymes.include?(r[-1])
	 	@d << r 
	 	@unique.delete(r)
	 end
	end

	@@data = @d.sort_by{|e| e[-1]}										
	
end

def is_word_alpha?(word)
	return word =~ /[A-Za-z]/
end

def detect_last_pos
	@temp = []
	 @@data.each do |d| 
	 	sentence_pos = parse_sentence d[0]
	 	last_word, last_word_pos = sentence_pos[-1][-1][0], sentence_pos[-1][-1][-1]

	 	realword = is_word_alpha?(last_word)
	 	last_word_pos = sentence_pos[-1][-2][-1] if realword.nil?

	 	d << last_word_pos
	 	@temp << d
	 end
	 @@data = @temp
end

def make_hash_of_rhyming_lines
	rhymes = {}
	@@data.map do |a| 
		if rhymes[a[2]]
			if rhymes[a[2]].length >= 1
				rhyme_array = rhymes[a[2]] << a[0]
				rhymes[a[2]] = rhyme_array
			end
		else
			rhymes[a[2]] =  [a[0]]
		end
	end
	@hash_rhyming_lines = rhymes
	@all_rhymes = @hash_rhyming_lines.dup
end



def get_random_word(array)
	randomarray = array[Random.rand(array.length)][0].split(" ")
	return randomarray
end

def get_long_word(array)
	get_random_word(array).longest.alpha_strip
end

def get_short_word(array)
	get_random_word(array).shortest.alpha_strip
end
	
def get_short_phrase n
	@@markov.generate_n_words(n)
end




##### Separate dictionaries for each artist - not working very well as not enough input sources currently

def make_artist_dictionaries
	Dir.glob("#{source}/*/*").each do |folder|

		path,artistname = File.split(folder)
		p artistname

		markov = MarkyMarkov::Dictionary.new("#{artistname}") # Saves/opens dictionary.mmd
			Dir.glob("#{folder}/*.txt").each do |f|
				begin
					problematic_files.each{|a| next if f.include?(a)}
					markov.parse_file f
				rescue ArgumentError => e
					puts "#{e}: #{f}"
				end
			end
		markov.save_dictionary!
	end
end

def print_examples_from_artist_dictionaries
	Dir.glob("#{Dir.pwd}/*.mmd").each do |dictionary|
		artist = File.basename(dictionary, ".mmd")
		markov = MarkyMarkov::Dictionary.new(artist)
		p "+++#{artist}++++"

		5.times do
			num = Random.rand(11) + 10
			words = markov.generate_n_words num
			words.split(" ").each do |w|
				words.delete!(w) if w.downcase.include?("chorus") or w.downcase.include?("verse") \
								or w.downcase.include?("[") or w.downcase.include?("\\") 
			end
			
			p "#{num}:#{words}"
			
		end
		p "---"
	end
end





