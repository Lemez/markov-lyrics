class AddDaftnessReasonToLines < ActiveRecord::Migration
  def change
  	  	add_column :lines, :reason_for_daftness, :string
  end
end
