# run with  
# rackup
# and access at http://localhost:9292/ or http://rebeats-markov.dev:9292/

Migrations - HOW TO

1) create migration
	bundle exec rake db:create_migration NAME=create_words_table_again

2) create a table

	def change
		create_table :lines do |t|
		      t.integer :line_number
		end
	end

OR modify existing tables

	def change
	  	rename_column :songs, :numer_of_shares, :number_of_shares
	  	add_column :lines, :line, :string
	end


3) make change on db

	bundle exec rake db:migrate