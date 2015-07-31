
require 'awesome_print'

# require 'words'
# require 'wordnet'
# WORDS = WordNet::Sense.new

Dir.glob('./models/*').each{|f| require_relative f}
Dir.glob('./*.rb').each{|f| require_relative f unless File.basename(f, 'rb')=="a"}


def get_markov_data(pattern,speed,pitch)

	# setup_song(pattern,speed,pitch)
	
	# print_markov(NUMBER)

	# keep_going_if_not_enough

	# sort_lines_into_rhymes
	# detect_last_pos
	# define_verse_pattern
	# make_chorus

	# add_syllable_count_to_verses
	# get_ipa line

	setup_song(pattern,speed,pitch)
	print_markov_simpler(NUMBER)
	sort_lines_into_rhymes
	define_verse_pattern
	make_chorus
end

def keep_going_if_not_enough
	while @@data.length < 50
		p @@data.length
	  	 print_markov(NUMBER)
	end
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






	







