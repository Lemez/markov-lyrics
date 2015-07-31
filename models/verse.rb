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
			@line = Line.new({:line_number => number,
						:line => text, 
						:verse_id=> verse_id
												})
			@line.set_line_pos_syl_rhymes(text)
			@line.save!
		end
  end

  def lines
		Line.where(verse_id: @id)
  end

end