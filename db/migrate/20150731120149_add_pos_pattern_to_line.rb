class AddPosPatternToLine < ActiveRecord::Migration
  def change
  	add_column :lines, :is_daft, :boolean, :default => false
  end
end
