class Line < ActiveRecord::Base
  belongs_to :stanza
  has_many :words

  store :settings, accessors: [:line_number, :number_of_words, :number_of_syllables, :last_word_rhyme, :last_word_pos, :line, :has_rhyme], coder: JSON

end