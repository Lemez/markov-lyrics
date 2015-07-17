class Token < ActiveRecord::Base
	belongs_to :word
	# attr_accessor :pos, :position_in_word
	
end