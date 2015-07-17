class CreateStanzas < ActiveRecord::Migration
  def change
  	create_table :stanzas do |t|
      t.string :type
      t.integer :number_of_lines
      t.string :pattern
      t.integer :position_in_song
    end
  end
end
