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
			@line = Line.new({:line_number => number,
										:line => text, 
										:chorus_id=> chorus_id
												})
			@line.set_line_pos_syl_rhymes(text)
			@line.save!
		end
  	end

end