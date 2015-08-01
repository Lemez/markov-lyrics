class AddDaftnessReasonToLines < ActiveRecord::Migration
  def change
  	  	add_column :lines, :why_daft, :string
  end
end
