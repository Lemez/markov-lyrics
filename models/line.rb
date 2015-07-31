class Line < ActiveRecord::Base
  belongs_to :song
  has_many :words

  # store :settings, accessors: [:line_number, :number_of_words, :number_of_syllables, :last_word_rhyme, :last_word_pos, :line, :has_rhyme, :stanza_id], coder: JSON

  scope :from_chorus, ->(id) { where(chorus_id: id) }


  def init (options={})

	  	@line_number = options[:line_number]
	  	@line = options[:line]
  		@verse_id = options[:verse_id] 
  		@chorus_id = options[:chorus_id] 
      @number_of_words = options[:number_of_words]
      @number_of_syllables = options[:number_of_syllables]
      @last_word_rhyme = options[:last_word_rhyme]
      @last_word_pos = options[:last_word_pos]

  end

end
