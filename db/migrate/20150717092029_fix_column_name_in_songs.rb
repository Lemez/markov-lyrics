class FixColumnNameInSongs < ActiveRecord::Migration
  def change
  	rename_column :songs, :numer_of_shares, :number_of_shares
  end
end
