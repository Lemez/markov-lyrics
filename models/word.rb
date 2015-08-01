class Word < ActiveRecord::Base
	belongs_to :line
	has_many :tokens

	# store :settings, accessors: [:word, :number_of_tokens, :lemma, :meaning, :rhyme, :position_in_line], coder: JSON

	 #  scope :from_chorus, ->(id) { where(chorus_id: id) }
  # scope :not_daft, -> { where(is_daft: false) }


  def init (options={})

	  @position_in_line = options[:position_in_line]
	  @word = options[:word]
  	  @lemma = options[:lemma] 
  	  @line_id = options[:line_id] 

  end

  # def create_token(id,position, )

  # 	 options={}

  # 	 options[:position_in_word] = position
  #    options[:pos]
	 # options[:lemma] 
	 # options[:token] = 
	 # options[:word_id] = id

  # 	@token = Token.create({
  #           options
  #           })
  # end

end