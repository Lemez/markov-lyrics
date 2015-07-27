class AddHasRhymeToLine < ActiveRecord::Migration
  def change
	  	add_column :lines, :has_rhyme, :boolean
	end
end
