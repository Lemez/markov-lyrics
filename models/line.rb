class Line < ActiveRecord::Base
  belongs_to :song
  has_many :words

  # store :settings, accessors: [:line_number, :number_of_words, :number_of_syllables, :last_word_rhyme, :last_word_pos, :line, :has_rhyme, :stanza_id], coder: JSON

  scope :from_chorus, ->(id) { where(chorus_id: id) }
  scope :not_daft, -> { where(is_daft: false) }


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

  def save_words!(id)

      options={}

      array = self.line.split(" ")
      @arraydup = array.dup
      positions = []

      array.each do |w|

        # @word = Word.create

        repeated_words =  positions.include?(@arraydup.index(w))

        case repeated_words
        when false
            position_in_line = @arraydup.index(w)
            positions << position_in_line
        when true
            @arraydup -= @arraydup[position_in_line]
            position_in_line = @arraydup.index(w) + 1
        end

        options[:position_in_line] = position_in_line
        options[:word] = w.alpha_strip.chomp

        @nlp_results = get_tokens(w.prepare_for_parsing)
        # @nlp_results[:word_id] = @word.id
       
        # case @nlp_results[:number_of_tokens]
        # when 1

        #   @nlp_results[:position_in_word] = 0

        #   p @nlp_results

        #   # @word.create_token(@nlp_results)

        # when 2..10
          

        # end

         # options[:number_of_tokens] 
        # options[:lemma] = get_lemma(options[:word])
        # options[:line_id] = id

        # @word = Word.create({
        #     :position_in_line => position_in_line,
        #     :word => word, 
        #     :line_id=> line_id,
        #     :rhyme => text.split(" ").length,
        #     :number_of_syllables => get_syllables_better(text),
        #     :number_of_syllables => get_last_word_rhyme(text),
        #     :pos => get_sentence_pos(text)
        #                 })
      end

      
  end

end

