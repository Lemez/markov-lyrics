class AddNumberLinesToVerseAndChorus < ActiveRecord::Migration
  def change
  	add_column :verses, :number_lines, :integer
  end
end
