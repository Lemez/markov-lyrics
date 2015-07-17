class CreateWordsTableAgain < ActiveRecord::Migration
  def change
  	create_table :words do |t|
      t.integer :position_in_line
      t.string :rhyme
      t.string :meaning
      t.string :lemma
      t.string :word
      t.integer :number_of_tokens
  end
  end
end
