require 'marky_markov'
require 'awesome_print'
require 'trollop'


opts = Trollop::options do
  opt :words, "Use word mode"                    # flag --monkey, default false
  opt :sentences, "Use sentences mode"                    # flag --monkey, default false
  opt :minsyll, "minimum syllables", :type => :integer, :default => 6         # string --name <s>, default nil
  opt :maxsyll, "maximum syllables", :type => :integer, :default => 10  # integer --num-limbs <i>, default to 4
  opt :number, "number of items", :type => :integer, :default => 10         # string --name <s>, default nil
  
end


MIN = opts[:minsyll]
MAX = opts[:maxsyll]
WORDS = opts[:words]
SENTENCES = opts[:sentences]
NUMBER = opts[:number]




def setup_markov
	@@markov = MarkyMarkov::Dictionary.new('dictionary2', 2) # Saves/opens dictionary.mmd
	@@data = []
end

def get_markov_data
	setup_markov
	print_markov(NUMBER)
	keep_going_if_not_enough
end

def keep_going_if_not_enough
	while @@data.length < 5
		p @@data.length
	  	 print_markov(NUMBER)
	end
	
end

class String
	def clean_up
		words = self.split(" ")
		words.reject!{|w| w.downcase.include?("chorus") or w.downcase.include?("verse") \
										or w.downcase.include?("[") or w.downcase.include?("\\") \
										or w.downcase.include?("}") or w.downcase.include?("{") \
										or w.downcase.include?("]")
										}
		words.join(" ")
	end

	def separate_out
		separated = self.split(" ").map! {|s| s[0]==s[0].upcase && s!="I" ? s="\n#{s}" : s }.join(" ") 
		cleaner = separated.split("\n").map(&:strip).reject {|a| !a.include?(" ")}
		cleaner
	end
end

def get_syllables line
	syll = eval "->s{s.scan(/[aiouy]+e*|e(?!d$|ly).|[td]ed|le$/).size}" #get syllable size
	number_syllables = syll.call(line)
	number_syllables
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
	!WORDS.nil? ? sentences = @@markov.generate_n_words(n*10) : sentences = @@markov.generate_n_sentences(n)

	sentences.clean_up.separate_out.each do |line|
		number_syllables = get_syllables(line)
		if number_syllables>MIN && number_syllables<MAX && !@@data.include?([number_syllables, line])
			@@data << [number_syllables, line]
		end
	end
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





