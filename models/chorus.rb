class Chorus < ActiveRecord::Base

	belongs_to :song
  	has_many :lines

	# store :settings, accessors: [:song_id, :number_lines, :pattern], coder: JSON

	def init(options={})
		@song_id = options[:song_id]
	  @number_lines = options[:number_lines]
	  	
	end

	def self.number_lines
		@number_lines
	end

  	def save_lines(data)
  		chorus_id = self.id
		data.each_pair do |number,text| 

			@line = Line.create({
            			:line_number => number,
						:line => text, 
						:chorus_id=> chorus_id,
           				:number_of_words => text.split(" ").length,
           				:number_of_syllables => get_syllables_better(text),
            			:last_word_rhyme => get_last_word_rhyme(text),
            			:last_word_pos => get_sentence_pos(text)
												})

      p "1st pass at line: #{@line}, #{@line.last_word_rhyme}"

  	end
  end

end