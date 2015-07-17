class CreateSongs < ActiveRecord::Migration
   def change
  	create_table :songs do |t|
      t.integer :numer_of_shares
      t.datetime :created_at
      t.integer :number_of_stanzas
      t.string :created_by
    end
  end
end
