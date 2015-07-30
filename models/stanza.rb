class Stanza < ActiveRecord::Base
  validates_presence_of :type

  belongs_to :song
  has_many :lines

  store :settings, accessors: [:type, :number_lines, :pattern, :position_in_song], coder: JSON
  
  def init(type, song_id)
	  	@song_id = song_id
	  	@type = type
  end

  def save_as_chorus(data)
		@number_lines = data.keys.length
		@position_in_song = 0
		id = self.id
		data.each_pair{|number,text| Line.new(number,text,id).create}
  end

 def save_as_verse(data, position)
		@position_in_song = position+1,
		@number_lines = data.keys.length

		
								
 end

end