class Token < ActiveRecord::Base
	belongs_to :word
	# attr_accessor :pos, :position_in_word

	# store :settings, accessors: [:token, :pos, :position_in_word], coder: JSON

	def init (options={})

		  @position_in_word = options[:position_in_word]
		  @pos = options[:pos]
	  	  @lemma = options[:lemma] 
	  	  @token = options[:token] 
	  	  @word_id = options[:word_id] 

    end

end