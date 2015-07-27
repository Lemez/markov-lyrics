def get_syllables line
	syll = eval "->s{s.scan(/[aiouy]+e*|e(?!d$|ly).|[td]ed|le$/).size}" #get syllable size
	number_syllables = syll.call(line)
	number_syllables
end

def get_syllables_better line
	line.to_phrase.syllables
end