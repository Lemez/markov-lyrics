def get_syllables line
	syll = eval "->s{s.scan(/[aiouy]+e*|e(?!d$|ly).|[td]ed|le$/).size}" #get syllable size
	number_syllables = syll.call(line)
	number_syllables
end

def get_syllables_better line
	line.to_phrase.syllables
end

def add_syllable_count_to_verses
	@syllable_array = []
	v = @@verses[0].values.map(&:first).map{|s| s.split(" ")}
	p v
	v.each do |line| 
		l = []
		line.each do |word| 
			l << [word, get_syllables_better(word.chomp)]
		end
		@syllable_array << l
	end
	p @syllable_array
end