class AddIdsToModels < ActiveRecord::Migration
  def change
  	add_column :tokens, :word_id, :int
  	add_column :words, :line_id, :int
  	add_column :lines, :stanza_id, :int
  	add_column :stanzas, :song_id, :int
  end
end
