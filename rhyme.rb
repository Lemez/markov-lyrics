require 'ruby_rhymes'
require 'rhymes'

RHYMES = Rhymes.new 

def sort_lines_into_rhymes

	@d = @@data.dup
	@unique = @d.uniq {|x| get_last_word_rhyme(x)}
	@d -= @unique

	d_rhymes = @d.map{|c| get_last_word_rhyme(c)}

	@unique.each do |r|
	 if d_rhymes.include?(get_last_word_rhyme(r))
	 	@d << r 
	 	@unique.delete(r)
	 end
	end

	@@data = @d.sort_by{|e| get_last_word_rhyme(e)}										
	
end

def make_hash_of_rhyming_lines
	rhymes = {}
	@@data.map do |a| 
		r = get_last_word_rhyme(a)
		if rhymes[r]
			if rhymes[r].length >= 1
				rhyme_array = rhymes[r] << a
				rhymes[r] = rhyme_array
			end
		else
			rhymes[r] =  [a]
		end
	end
	@hash_rhyming_lines = rhymes
	@all_rhymes = @hash_rhyming_lines.dup
end

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

def add_daft_to_bad_lines(ids)
	Line.where(:id => ids).each do |line|
		line.is_daft = true
		line.save!
	end
end

