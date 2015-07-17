class Word < ActiveRecord::Base
	belongs_to :line
	has_many :tokens
end