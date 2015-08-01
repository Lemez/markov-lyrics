def save_song_data_to_db

	@song = Song.new(pattern: @pattern,
						 number_of_verses: @@verses.length)
	@song.save!

	@chorus = Chorus.new(number_lines: @@chorus.keys.length,
							 song_id: @song.id)
	@chorus.save!

	@chorus.save_lines(@@chorus)

	@@verses.each_with_index do |verse_hash, i|
		@verse = Verse.new(song_id: @song.id,
							 number_lines: verse_hash.keys.length,
							 position: i+1 )

		@verse.save!
		@verse.save_lines(verse_hash)

	end

	@song
end

def store_line_attributes params

	params.each_pair do |quality,hash|
		quality=='good' ? attribute = :is_good : attribute = :is_daft

		hash.each_pair do |id,reason|

			Line.update(id, attribute => true, :why_daft => reason)

			p "Line #{id} is #{quality}, due to #{reason}"

		end
	end
end