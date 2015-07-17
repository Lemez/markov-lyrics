class CreateTokens < ActiveRecord::Migration
  def change
  	create_table :tokens do |t|
      t.string :token
      t.string :pos
      t.integer :position_in_word
  	end
  end
end
