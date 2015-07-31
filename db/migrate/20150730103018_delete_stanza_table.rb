class DeleteStanzaTable < ActiveRecord::Migration
  def change
  	drop_table :stanzas
  end
end
