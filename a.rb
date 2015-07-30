
require 'awesome_print'

# require 'words'
# require 'wordnet'
# WORDS = WordNet::Sense.new

require_relative './array'
require_relative './string'
require_relative './verse'
require_relative './models/song'

require_relative './markov'
require_relative './song_methods'
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

	# add_syllable_count_to_verses
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



def detect_last_pos
	@temp = []
	 @@data.each do |d| 

	 	last_word_pos = get_sentence_pos(d)

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




	







