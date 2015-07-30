PATTERNS = ['AABB', 'ABAB', 'ABBA']

# line
# :line_number, :number_of_words, :number_of_syllables, :last_word_rhyme, :last_word_pos, :line, :has_rhyme



def save_song_data_to_db

	Song.new(@pattern,@@verses) do |song|

		chorus = Stanza.new("chorus",song.id)
		chorus.save_as_chorus(@@chorus)

		song.each_with_index do |verse_hash, i|

			verse = Stanza.new("verse",song.id)

			verse.save_as_verse(verse_hash, i)

			verse_hash.each_pair do |line_no, line_data|
				text = line_data[0]

				line = Line.new()
			end

		end
	

	end
	
end



def validate_pattern (pattern)
	pattern = "ABAB" if pattern.nil? or !PATTERNS.include?(pattern) 
	p "======pattern=#{pattern}=="
	@pattern = pattern
end

def validate_speed (speed)
	speed = SPEED if speed.nil? or speed.empty?
	p "speed=#{speed}======="
	@speed = speed
end

def validate_pitch (pitch)
	pitch = 90 if pitch.nil? or pitch.empty? 
	p "pitch=#{pitch}======="
	@pitch = pitch
end

def setup_song(pattern,speed,pitch)

	@@data = []
	@last = ''

	validate_pattern(pattern)
	validate_speed(speed)
	validate_pitch(pitch)
	
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
	# get_meaning @hook_keyword
	
end