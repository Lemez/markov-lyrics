class RenameStanzaidColumn < ActiveRecord::Migration
  def change
  	rename_column :lines, :stanza_id, :verse_id
  	add_column :lines, :chorus_id, :integer
  	add_column :choruses, :song_id, :integer
  	add_column :verses, :song_id, :integer
  end
end
