class AddIsDaftValueToAllOldLines < ActiveRecord::Migration
  def change
  	Line.find_each do |line|
  		line.is_daft = false
  		line.save!
  	end
  end
end
