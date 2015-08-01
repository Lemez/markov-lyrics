require 'string_to_ipa'
require 'stanford-core-nlp'

def set_up_nlp (word)
	text = NLP.annotate(StanfordCoreNLP::Annotation.new(word))
	text
end

def get_tokens(word)

	text = set_up_nlp (word)

	@tokens = 0
	text.get(:tokens).each {|token| @tokens += 1}
	# @text.get(:tokens).each {|token| p token.get(:value).to_s} if @tokens > 1
	@tokens
end

def get_nlp word
	results = {}

	@tokens = 0
	set_up_nlp(word).get(:tokens).each do |token|
		@tokens =+ 1
		results[:token] = token.get(:value).to_s
		results[:lemma] = token.get(:lemma).to_s
		results[:pos]  = token.get(:part_of_speech).to_s
	end

	results[:number_of_tokens] = @tokens
	results

end

def parse_sentence textinput
	words = []

	set_up_nlp(textinput).get(:sentences).each do |sentence|
		sentenceAnnotated = []
        # Syntatical dependencies
	    # puts sentence.get(:basic_dependencies).to_s
	    sentence.get(:tokens).each do |token|
		    # Default annotations for all tokens
		    # puts token.get(:value).to_s
		     sentenceAnnotated << [token.get(:original_text).to_s, token.get(:part_of_speech).to_s]
		    # puts token.get(:character_offset_begin).to_s
		    # puts token.get(:character_offset_end).to_s
		    # POS returned by the tagger

		    # Lemma (base form of the token)
		    # puts token.get(:lemma).to_s
		    # Named entity tag
		    # puts token.get(:named_entity_tag).to_s
		    # Coreference
		    # puts token.get(:coref_cluster_id).to_s
		    # Also of interest: coref, coref_chain,
		    # coref_cluster, coref_dest, coref_graph.
	  	end
	  	words << sentenceAnnotated
	end
	words
end

def get_sentence_pos(d)
		sentence_pos = parse_sentence d
	 	last_word, last_word_pos = sentence_pos[-1][-1][0], sentence_pos[-1][-1][-1]

	 	realword = is_word_alpha?(last_word)
	 	last_word_pos = sentence_pos[-1][-2][-1] if realword.nil?

	 	return last_word_pos
end


def get_ipa line
	words = line.gsub(/[^A-Za-z ]/i, '')
	# p words.split(" ").map{|e| e.to_ipa}
	p "hello".to_ipa
end