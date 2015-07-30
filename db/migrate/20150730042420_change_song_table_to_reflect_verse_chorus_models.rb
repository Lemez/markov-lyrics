class ChangeSongTableToReflectVerseChorusModels < ActiveRecord::Migration
  def change
  	add_column :songs, :song_pattern, :string
  	add_column :songs, :number_of_verses, :integer
  	remove_column :songs, :number_of_stanzas, :integer
  end
end
