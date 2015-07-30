class Song < ActiveRecord::Base
  validates_presence_of :created_at
  has_many :stanzas

  	store :settings, accessors: [:number_of_stanzas, :created_at, :created_by, :number_of_shares], coder: JSON


  	def init(pattern,data)
  		@pattern = pattern
  		@number_of_stanzas = data.length
  	end

end