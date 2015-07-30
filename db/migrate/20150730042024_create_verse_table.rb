class CreateVerseTable < ActiveRecord::Migration
  def change
  	create_table :verses do |t|
		      t.integer :position
		      t.string	:pattern
		end
  end
end
