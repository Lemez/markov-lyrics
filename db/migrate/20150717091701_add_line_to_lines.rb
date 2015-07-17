class AddLineToLines < ActiveRecord::Migration
  def change
    add_column :lines, :line, :string
  end
end
