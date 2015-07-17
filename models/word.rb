class Word < ActiveRecord::Base
	belongs_to :line
	has_many :tokens

	store :settings, accessors: [:word, :number_of_tokens, :lemma, :meaning, :rhyme, :position_in_line], coder: JSON

end