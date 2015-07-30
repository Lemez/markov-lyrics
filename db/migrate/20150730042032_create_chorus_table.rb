class CreateChorusTable < ActiveRecord::Migration
  def change
  	create_table :choruses do |t|
		      t.string	:pattern
		end
  end
end
