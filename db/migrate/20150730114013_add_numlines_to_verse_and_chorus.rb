class AddNumlinesToVerseAndChorus < ActiveRecord::Migration
  def change
  	add_column :songs, :number_lines, :integer
  	add_column :choruses, :number_lines, :integer
  end
end
