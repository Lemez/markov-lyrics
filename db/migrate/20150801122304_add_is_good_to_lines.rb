class AddIsGoodToLines < ActiveRecord::Migration
  def change
  	add_column :lines, :is_good, :boolean, :default => false
  end
end
