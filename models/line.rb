class Line < ActiveRecord::Base
  belongs_to :stanza
  has_many :words

  store :settings, accessors: [:line_number, :number_of_words, :number_of_syllables, :last_word_rhyme, :last_word_pos, :line, :has_rhyme, :stanza_id], coder: JSON

  def init (number,text, id)

	  	@line_number = number
	  	@number_of_words = text.split(" ").length
	  	@number_of_syllables = get_syllables_better text
	  	@line => text
	  	@last_word_rhyme = get_last_word_rhyme(text)
	  	@last_word_pos => get_sentence_pos(text)
	  	@stanza_id => id

  end


end
