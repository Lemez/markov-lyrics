class Verse < ActiveRecord::Base

  belongs_to :song
  has_many :lines
  # store :settings, accessors: [:song_id, :number_lines, :pattern, :position_in_song], coder: JSON

  def init(options={})
  	  	@song_id = options[:song_id]
  	  	@number_lines = options[:number_lines]
  	  	@position = options[:position]
  end

  def save_lines(data)
  		verse_id = self.id
		  data.each_pair do |number,text| 

			@line = Line.create({
            :line_number => number,
						:line => text, 
						:verse_id=> verse_id,
            :number_of_words => text.split(" ").length,
            :number_of_syllables => get_syllables_better(text),
            :last_word_rhyme => get_last_word_rhyme(text),
            :last_word_pos => get_sentence_pos(text)
												})

      p "1st pass at line: #{@line.number_of_words}"

		end
  end

  def lines
		Line.where(verse_id: @id)
  end

end