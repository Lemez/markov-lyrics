require 'marky_markov'
require 'awesome_print'
require 'trollop'
require 'stanford-core-nlp'
require 'rhymes'
require 'string_to_ipa'
require 'ruby_rhymes'

require_relative './array'
require_relative './string'
require_relative './verse'

opts = Trollop::options do
  opt :words, "Use word mode"                    # flag --monkey, default false
  opt :sentences, "Use sentences mode"                    # flag --monkey, default false
  opt :minsyll, "minimum syllables", :type => :integer, :default => 6         # string --name <s>, default nil
  opt :maxsyll, "maximum syllables", :type => :integer, :default => 8  # integer --num-limbs <i>, default to 4
  opt :number, "number of items", :type => :integer, :default => 100         # string --name <s>, default nil
  
end


MIN = opts[:minsyll]
MAX = opts[:maxsyll]
WORDS = opts[:words]
SENTENCES = opts[:sentences]
NUMBER = opts[:number]

PATTERNS = ['AABB', 'ABAB', 'ABBA']

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

def get_ipa line
	words = line.gsub(/[^A-Za-z ]/i, '')
	# p words.split(" ").map{|e| e.to_ipa}
	p "hello".to_ipa
end

def parse_sentence textinput
	words = []
	text = StanfordCoreNLP::Annotation.new(textinput)
	NLP.annotate(text)

	text.get(:sentences).each do |sentence|
		sentenceAnnotated = []
        # Syntatical dependencies
	    # puts sentence.get(:basic_dependencies).to_s
	    sentence.get(:tokens).each do |token|
		    # Default annotations for all tokens
		    # puts token.get(:value).to_s
		     sentenceAnnotated << [token.get(:original_text).to_s, token.get(:part_of_speech).to_s]
		    # puts token.get(:character_offset_begin).to_s
		    # puts token.get(:character_offset_end).to_s
		    # POS returned by the tagger

		    # Lemma (base form of the token)
		    # puts token.get(:lemma).to_s
		    # Named entity tag
		    # puts token.get(:named_entity_tag).to_s
		    # Coreference
		    # puts token.get(:coref_cluster_id).to_s
		    # Also of interest: coref, coref_chain,
		    # coref_cluster, coref_dest, coref_graph.
	  	end
	  	words << sentenceAnnotated
	end
	words
end

def setup_markov
	@@markov = MarkyMarkov::Dictionary.new('dictionary2', 2) # Saves/opens dictionary.mmd
end

def validate_pattern pattern
	pattern = "ABAB" if !PATTERNS.include?(pattern) or pattern.nil?
	p "======pattern=#{pattern}========="
	@pattern = pattern
end

def setup_song

	@@data = []
	@last = ''

	validate_pattern(pattern)
	@song = Song.new(pattern: @pattern)
	
end

def get_markov_data(pattern="ABAB")
	
	setup_song
	
	print_markov(NUMBER)
	keep_going_if_not_enough

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

def get_syllables line
	syll = eval "->s{s.scan(/[aiouy]+e*|e(?!d$|ly).|[td]ed|le$/).size}" #get syllable size
	number_syllables = syll.call(line)
	number_syllables
end

def get_syllables_better line
	line.to_phrase.syllables
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



def print_markov n

	setup_markov

	!WORDS.nil? ? sentences = @@markov.generate_n_words(n*10) : sentences = @@markov.generate_n_sentences(n)

	sentences.clean_up.separate_out.each do |line|
		number_syllables = get_syllables_better(line)
		rhyme = get_last_word_rhyme(line)
		if number_syllables>MIN && number_syllables<MAX && !@@data.include?([number_syllables, line]) && !rhyme.nil?
			@@data << [line, number_syllables, rhyme]
		end
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

def create_verse

	@verse = {}

	@hash_rhyming_lines.each_pair do |k,v|

		case @pattern
		when 'ABAB'
			@a1,@a2,@b1,@b2 = 1,3,2,4
		when 'AABB'
			@a1,@a2,@b1,@b2 = 1,2,3,4
		when 'ABBA'
			@a1,@a2,@b1,@b2 = 1,4,2,3
		end

		p "pattern:#{@pattern}"
		p "a1,a2,b1,b2:#{[@a1,@a2,@b1,@b2].to_s}"
		first,second,third,fourth = @a1,@a2,@b1,@b2
		
		if v.size==4 && !@verse.has_key?(@a1)
			@verse[first],@verse[second] = v[0],v[1]
			@hash_rhyming_lines[k] -= v[0..1]

		elsif v.size==4 && !@verse.has_key?(@b1)
			@verse[third],@verse[fourth] = v[0],v[1]
			@hash_rhyming_lines[k] -= v[0..1]

		elsif v.size==3 && !@verse.has_key?(@a1)
			@verse[first],@verse[second], @last = v[0],v[1],v[2]
			@hash_rhyming_lines.delete(k)

		elsif v.size==3 && !@verse.has_key?(@b1)
			@verse[third],@verse[fourth], @last = v[0],v[1],v[2]
			@hash_rhyming_lines.delete(k)

		elsif v.size==2 && !@verse.has_key?(@a1)
			@verse[first],@verse[second] = v[0],v[1]
			@hash_rhyming_lines.delete(k)

		elsif v.size==2 && !@verse.has_key?(@b1)
			@verse[third],@verse[fourth] = v[0],v[1]
			@hash_rhyming_lines.delete(k)

		end	
	end

	@all_lines = @@data.map{|a| a[0]}

	p "verse: #{@verse}"

	@verse.each_pair do |number, line|
		data_index = @all_lines.index(line)
		@verse[number] = @@data[data_index]
	end

	p "verse: #{@verse}"

	@verse[3].nil? ? @more_to_extract = false : @@verses << @verse

end

def define_verse_pattern

	@@verses = []
	@more_to_extract = true
	
	make_hash_of_rhyming_lines	

	while @hash_rhyming_lines.keys.size > 1 && @more_to_extract 
		
		create_verse

	end
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

def make_chorus
	@chorus_words = []
	biggest = @all_lines.flat_map{|a| a.split(" ")}.group_by(&:size).max.last
	chorus_words_pos = parse_sentence biggest.join(" ")
	biggest.map do |a| 
		realword = is_word_alpha?(a)
		unless realword.nil? 
			@chorus_words << chorus_words_pos[biggest.index(a)]
			
		end
	end

	@hook_keyword = @chorus_words.flatten.first
	@all_lines.each{|a| @hook = a if a.include?(@hook_keyword)}

	@other_hooks = []
	@other_hook_words = @hook.split(" ").map{|a| a.gsub(/[^A-Za-z]/,"")}.reject{|b|b.empty?}

	@other_hook_words.each do |word|
		@all_lines.each{|a| @other_hooks << a if a.include?(word) \
											&& a!= @hook \
											&& word.length > 4 }
	end

	rhyme = get_last_word_rhyme(@hook)

	@last=@all_rhymes[rhyme].first if @last.empty? 
	@other=get_short_phrase(4)

	@@chorus = {
		1 =>  @hook.capitalize,
		2 => "#{@hook_keyword.capitalize}, #{@hook_keyword.capitalize}",
		3 =>  @last,
		4 =>  @other.capitalize,
		5 =>  @hook_keyword.capitalize
	}

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





