require 'marky_markov'
require 'parallel'

def setup_markov
	@@markov = MarkyMarkov::Dictionary.new('dictionary2', 2) # Saves/opens dictionary.mmd
end

def get_short_phrase n
	@@markov.generate_n_words(n)
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

def print_markov_simpler n

	setup_markov

	!WORDS.nil? ? sentences = @@markov.generate_n_words(n*10) : sentences = @@markov.generate_n_sentences(n)

	cleaned = sentences.clean_up.separate_out

	cleaned.each do |line|
		number_syllables = get_syllables_better(line)
		rhyme = get_last_word_rhyme(line)

		unless @@data.include?(line) or rhyme.nil? or number_syllables > MAX or number_syllables < MIN
			@@data << line
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