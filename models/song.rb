class Song < ActiveRecord::Base

  has_many :verses
  has_one :chorus
  
  # accepts_nested_attributes_for :verses

  # store :settings, accessors: [:number_of_verses, :created_by, :number_of_shares], coder: JSON

  	def init(options={})
  		@pattern = options[:pattern]
  		@number_of_verses = options[:number_of_verses]
  	end

end