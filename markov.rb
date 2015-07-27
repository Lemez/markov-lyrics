require 'marky_markov'
require 'parallel'

def setup_markov
	@@markov = MarkyMarkov::Dictionary.new('dictionary2', 2) # Saves/opens dictionary.mmd
end

def print_markov n

	setup_markov

	!WORDS.nil? ? sentences = @@markov.generate_n_words(n*10) : sentences = @@markov.generate_n_sentences(n)

	cleaned = sentences.clean_up.separate_out

	cleaned.each do |line|
	# Parallel.each(cleaned) do |line| 
		number_syllables = get_syllables_better(line)
		rhyme = get_last_word_rhyme(line)
		unless @@data.include?([line, number_syllables, rhyme]) or rhyme.nil? or number_syllables > MAX or number_syllables < MIN
			@@data << [line, number_syllables, rhyme]
			p @@data.length
		end
	end
end

def make_dictionary
	source = "/Users/JW/Dropbox/_w/T10 NLP/corpus files/original corpus files"
	problematic_files = ['Il_Divo/Passera','Il_Divo/Ti_Amero', 'Lady_Gaga/Scheisse', 'Feliz_Navidad']

	Dir.glob("#{source}/*/*/*.txt").each do |file|

		begin
			problematic_files.each{|a| next if file.include?(a)}
			@@markov.parse_file file
		rescue ArgumentError => e
			puts "#{e}: #{file}"
		end
		 	
	end
	@@markov.save_dictionary!
end