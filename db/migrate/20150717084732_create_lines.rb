class CreateLines < ActiveRecord::Migration
   def change
  	create_table :lines do |t|
      t.integer :line_number
      t.integer :number_of_words
      t.integer :number_of_tokens
      t.integer :number_of_syllables
      t.string :last_word_rhyme
      t.string :last_word_pos
    end
  end
end
