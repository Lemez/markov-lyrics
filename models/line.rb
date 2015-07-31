class Line < ActiveRecord::Base
  belongs_to :stanza
  has_many :words

  # store :settings, accessors: [:line_number, :number_of_words, :number_of_syllables, :last_word_rhyme, :last_word_pos, :line, :has_rhyme, :stanza_id], coder: JSON

  scope :from_chorus, ->(id) { where(chorus_id: id) }


  def init (options={})

	  	@line_number = options[:line_number]
	  	@line = options[:line]
  		@verse_id = options[:verse_id] 
  		@chorus_id = options[:chorus_id] 

  end

  def set_line_pos_syl_rhymes(text)
  	 @number_of_words = text.split(" ").length
	   @number_of_syllables = get_syllables_better text
	   @last_word_rhyme = get_last_word_rhyme(text)
	   @last_word_pos = get_sentence_pos(text)
  end
end
