class Token < ActiveRecord::Base
	belongs_to :word
	# attr_accessor :pos, :position_in_word

	store :settings, accessors: [:token, :pos, :position_in_word], coder: JSON

end